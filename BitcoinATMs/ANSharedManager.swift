//
//  ANSharedManager.swift
//  BitcoinATMs
//
//  Created by Andrei Nechaev on 4/19/15.
//  Copyright (c) 2015 Andrei Nechaev. All rights reserved.
//

import UIKit

class ANSharedManager {
    static let sharedInstance = ANSharedManager()
    
    var viewController: CurrenciesTableViewDelegate?
    var tableViewController: UITableViewController?
    
    var sharedIndexes: [Int]?
    
    private init() {
        println(__FUNCTION__)
    }
}
