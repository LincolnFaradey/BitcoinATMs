//
//  ANDownloader.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 2/19/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit

class ANDownloader: NSObject {

    override init () {
        
    }
    
    class func getJSONFromURL(#url: NSURL, completiton: (NSData?, UIAlertController?) -> ()) {
        let request = NSURLRequest(URL: url)
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if (data != nil && error == nil) {
                completiton(data, nil)
            }else {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                completiton(nil, alertController)
            }
        }).resume()
    }
    
    class func loadCurrency(currency: String, handler: (NSNumber)->()) {
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url.URLByAppendingPathComponent(currency)), queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data != nil && error == nil {
                var currencyInfo = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil) as! NSDictionary?
                if currencyInfo != nil {
                    handler((currencyInfo!["ask"] as! NSNumber))
                }
            }
        }
    }
    
    class func getAveragePrice(handler: (String)->()) {
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url.URLByAppendingPathComponent("USD")), queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data != nil && error == nil {
                var currencyInfo = NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments, error: nil) as! NSDictionary?
                if currencyInfo != nil {
                    let price = currencyInfo!["ask"] as! NSNumber!
                    let avg = currencyInfo!["24h_avg"] as! NSNumber!
                    let str = NSString(format: "%.2f", price.doubleValue * 100 / avg.doubleValue - 100.0)
                    handler("\(str)%")
                }
            }
        }
    }
}
