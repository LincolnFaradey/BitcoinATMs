//
//  BitPointAnnotation.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 3/8/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import MapKit

class BitPointAnnotation: MKPointAnnotation {
    
    var type: String?
    var url: NSURL?    
    var isTwoWay: Bool?
    var types: NSDictionary?
}
