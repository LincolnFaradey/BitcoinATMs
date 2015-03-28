//
//  DetailsViewController.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 3/8/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var twoWayLabel: UILabel!
    @IBOutlet weak var openLink: UIButton!
    
    @IBOutlet weak var bitcoinImageView: UIImageView!
    @IBOutlet weak var litecoinImageView: UIImageView!
    @IBOutlet weak var dogecoinImageView: UIImageView!
    
    var webPage:NSURL?
    var isTwoWay: String?
    var bitTypes: NSDictionary?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.contents = UIImage(named: "Lamassu")?.CGImage
        self.view.layer.contentsGravity = kCAGravityResizeAspect
        

        self.bitcoinImageView.center.x += self.view.bounds.width
        self.litecoinImageView.center.x += self.view.bounds.width
        self.dogecoinImageView.center.x += self.view.bounds.width
        
        self.bitcoinImageView.alpha = 0.0
        self.litecoinImageView.alpha = 0.0
        self.dogecoinImageView.alpha = 0.0
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        twoWayLabel.text = isTwoWay
        self.hasCurrency()

        self.twoWayLabel.textColor = isTwoWay == "YES" ? UIColor.greenColor() : UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println(__FUNCTION__)
    }
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let webViewVC = segue.destinationViewController as! WebViewController
        webViewVC.webPage = webPage
    }
    
    //MARK: - HELPERS
    func hasCurrency() {
        
        for (key, value) in bitTypes! {
            println("\(value) \(key)")
            if key as! String == "bitcoin" && value as! String == "1" {
                animateRotationWith(self.bitcoinImageView, delay: 0.0, rotation: -1)
                animateAppearence(self.bitcoinImageView, delay: 0.0)
            }else if key as! String == "litecoin"  && value as! String == "1" {
                animateRotationWith(self.litecoinImageView, delay: 0.2, rotation: -1)
                animateAppearence(self.litecoinImageView, delay: 0.2)
            }else if key as! String == "dogecoin"  && value as! String == "1" {
                animateRotationWith(self.dogecoinImageView, delay: 0.4, rotation: -1)
                animateAppearence(self.dogecoinImageView, delay: 0.4)
            }
        }
    }
    
    func animateRotationWith(imageView: UIImageView, delay: Double, rotation: CGFloat) {
        let fullR = CGFloat(M_PI * 2)
        
        UIView.animateKeyframesWithDuration(1.5, delay: delay, options: UIViewKeyframeAnimationOptions.CalculationModeCubicPaced, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                imageView.transform = CGAffineTransformMakeRotation(1/3 * fullR * rotation)
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                imageView.transform = CGAffineTransformMakeRotation(2/3 * fullR * rotation)
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                imageView.transform = CGAffineTransformMakeRotation(3/3 * fullR * rotation)
            })
            }, completion: nil);
    }
    
    func animateAppearence(imageView: UIImageView, delay: Double) {
        UIView.animateWithDuration(1.5, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            imageView.alpha = 1.0
            imageView.center.x -= self.view.bounds.width
        }, completion: nil)
    }

}
