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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        (self.view as! WKWebView).loadRequest(NSURLRequest(URL: self.webPage!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
