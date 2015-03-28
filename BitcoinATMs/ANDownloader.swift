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
}
