//
//  WebViewController.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 3/9/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webPage: NSURL?
    
    override func loadView() {
        self.view = WKWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        (self.view as! WKWebView).loadRequest(NSURLRequest(URL: self.webPage!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
