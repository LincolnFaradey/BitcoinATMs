//
//  BitMapViewController.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 2/18/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit
import MapKit

class BitMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var transportTypeControl: UISegmentedControl!
    @IBOutlet weak var locateButton: UIButton!
    
    var locationManager:CLLocationManager = CLLocationManager()
    var placemark: MKPlacemark!
    var distance: CLLocationDistance!
    var isUpdated: Bool = false
    
    var my_set: NSMutableSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self

        transportTypeControl.alpha = 0.0
        locateButton.alpha = 0.0
        locationManager.delegate = self
        distanceLabel.alpha = 0.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        //TEST
        let item = BitMapItem(type: "BlaBLa", latitude: NSDecimalNumber(string:"55.776062"), longitude: NSDecimalNumber(string:"37.572070"), url: "http://google.com", isTwoWay: true, bitTypes: NSDictionary(dictionary: ["bitcoin" : "1",
            "litecoin" : "1",
            "dogecoin" : "1"]))
        let pointAnnotation = BitPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(item.latitude.doubleValue, item.longitude.doubleValue)
        pointAnnotation.title = item.type
        pointAnnotation.url = NSURL(string: item.url)
        pointAnnotation.isTwoWay = item.is_two_way
        pointAnnotation.types = item.bit_types
        self.mapView.addAnnotation(pointAnnotation);
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: loading JSON data 
    func loadCoordinates() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let json = userDefaults.objectForKey("mapData") as? NSDictionary
        if json != nil {
            self.loadDataWith(json!)
        }else {
            println("Not there")
            ANDownloader.getJSONFromURL(url: map_url) { (data: NSData?, alertController: UIAlertController?) -> () in
                if alertController != nil {
                    self.presentViewController(alertController!, animated: true, completion: nil)
                } else {
                    var error:NSErrorPointer = nil
                    let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: error) as! NSDictionary
                    
                    userDefaults.setObject(json, forKey: "mapData");
                    
                    self.loadDataWith(json)
                }
            }
        }
    }
    
    //MARK: MapKit delegates
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        if (!isUpdated) {
            let region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), span: MKCoordinateSpanMake(0.3, 0.3))
            self.mapView.region = region
            loadCoordinates()
            isUpdated = true
        }
    }
    
    func mapView(_mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if _mapView.userLocation.coordinate.latitude == annotation.coordinate.latitude {
            return nil
        }
        
        let pinView: MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinView")
        pinView.animatesDrop = true
        pinView.pinColor = .Red
        pinView.canShowCallout = true
        if (pinView.annotation.coordinate.latitude - mapView.userLocation.coordinate.latitude < 0.005 && pinView.annotation.coordinate.longitude - mapView.userLocation.coordinate.longitude < 0.005) {
            pinView.setSelected(true, animated: true)
        }

        pinView.leftCalloutAccessoryView = createButtonWithRect(CGRectMake(pinView.frame.origin.x, pinView.frame.origin.y, 23, 23), image:UIImage(named: "route")!, tag: 201)

        pinView.rightCalloutAccessoryView = createButtonWithRect(CGRectMake(pinView.frame.origin.x, pinView.frame.origin.y, 23, 23), image:UIImage(named: "info")!, tag: 202)
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay.isKindOfClass(MKPolyline)) {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay!)
            polylineRenderer.strokeColor = UIColor.purpleColor()
            polylineRenderer.lineWidth = 5.0
            
            return polylineRenderer
        }
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if control.tag == 201 {
            placemark = MKPlacemark(coordinate: view.annotation.coordinate, addressDictionary: nil)
            getDirection()
            self.mapView.deselectAnnotation(view.annotation, animated: true)
        }else {
            [self .performSegueWithIdentifier("details", sender: view.annotation)]
        }
        
    }
    

    //MARK: helpers
    func loadDataWith(json: NSDictionary) {
        self.my_set = NSMutableSet()
        json.enumerateKeysAndObjectsUsingBlock({ (key: AnyObject!, value: AnyObject!, tmp: UnsafeMutablePointer<ObjCBool>) -> Void in
            if value.isKindOfClass(NSDictionary) {
                let twValue = value["is_twoway"] as! NSNumber
                
                let item = BitMapItem(type: value["type"] as! String,
                    latitude: NSDecimalNumber(string: value["lat"] as? String),
                    longitude: NSDecimalNumber(string: value["long"] as? String),
                    url: value["url"]as! String,
                    isTwoWay: twValue == 1 ? true : false,
                    bitTypes: value["cryptos"] as! NSDictionary
                )
                
                self.my_set!.addObject(item.type)
                self.addAnnotationWith(item: item)
            }
        })
    }
    
    func addAnnotationWith(#item: BitMapItem) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let pointAnnotation = BitPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(item.latitude.doubleValue, item.longitude.doubleValue)
            
            
            if (pointAnnotation.coordinate.longitude - self.locationManager.location.coordinate.longitude < 0.5)  && (pointAnnotation.coordinate.longitude - self.locationManager.location.coordinate.longitude > -0.5) &&
                (pointAnnotation.coordinate.latitude - self.locationManager.location.coordinate.latitude < 0.5)  && (pointAnnotation.coordinate.latitude - self.locationManager.location.coordinate.latitude > -0.5){
                    pointAnnotation.title = item.type
                    pointAnnotation.url = NSURL(string: item.url)
                    pointAnnotation.isTwoWay = item.is_two_way
                    pointAnnotation.types = item.bit_types
                    self.mapView.addAnnotation(pointAnnotation);
            }
        })
    }
    
    func getDirection() {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.transportTypeControl.alpha = 1.0
            self.locateButton.alpha = 0.8
        })
        
        self.mapView.removeOverlays(self.mapView.overlays)
        let directionReqest = MKDirectionsRequest()
        directionReqest.setSource(MKMapItem.mapItemForCurrentLocation())
        directionReqest.setDestination(MKMapItem(placemark: placemark))
        
        switch transportTypeControl.selectedSegmentIndex {
        case 0:
           directionReqest.transportType = .Automobile
        case 1:
            directionReqest.transportType = .Walking
        default:
            directionReqest.transportType = .Any
        }
        let directions = MKDirections(request: directionReqest)
        directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse!, error: NSError!) -> Void in
            if (error != nil) {
                let errorMessage = UIAlertView(title: "Error",
                    message: error.localizedDescription,
                    delegate: self,
                    cancelButtonTitle: "Ok")
                errorMessage.show()
            }else {
                for tmp in response.routes {
                    let route = tmp as! MKRoute
                    self.distance = route.distance
                    self.mapView.addOverlay(route.polyline)
                    self.distanceLabel.text = NSString(format: "%.1fmiles", self.distance/1000 * 0.6213) as String
                    self.animateDistance()
                }
            }
        }
    }
    
    func animateDistance() {
        distanceLabel.center.y -= view.bounds.height
        view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(1.2, delay:0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.distanceLabel.center.y += self.view.bounds.height
            self.distanceLabel.alpha = 1.0
            }, completion: nil)
        
        for str in self.my_set! {
            println("Type \(str)")
        }
    }
    
    func createButtonWithRect(frame: CGRect, image: UIImage, tag: Int) -> UIButton {
        var button = UIButton(frame: frame)
        
        button.setImage(image, forState: UIControlState.Normal)
        button.contentMode = UIViewContentMode.ScaleAspectFit
        button.tag = tag

        return button
    }
    
    
    // MARK: IBActions
    @IBAction func focusOnUser(sender: UIButton) {
        if (locationManager.location == nil) { return }
        
        self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
    }
    
    @IBAction func transportType(sender: UISegmentedControl) {
        getDirection()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender!.isKindOfClass(BitPointAnnotation) {
            let controller = segue.destinationViewController as! DetailsViewController
            
            controller.webPage =  (sender as! BitPointAnnotation).url!
            controller.isTwoWay  = (sender as! BitPointAnnotation).isTwoWay! ? "YES" : "NO"
            controller.bitTypes = (sender as! BitPointAnnotation).types
        }
    }
}
