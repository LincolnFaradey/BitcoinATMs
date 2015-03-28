//
//  BitSingleton.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 3/17/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import Foundation

private let _sharedInstance = SharedManager()

class SharedManager {
    class func sharedInstance()-> SharedManager {
        return _sharedInstance;
    }
    
    
    
    private init() {
        
    }
}