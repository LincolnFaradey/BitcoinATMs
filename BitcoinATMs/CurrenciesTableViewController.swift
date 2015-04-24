//
//  CurrenciesTableViewController.swift
//  BitcoinATMs
//
//  Created by Andrei Nechaev on 4/13/15.
//  Copyright (c) 2015 Andrei Nechaev. All rights reserved.
//

import UIKit

protocol CurrenciesTableViewDelegate {
    func touchOccured(view: UITableViewCell)
}


class CurrenciesTableViewController: UITableViewController {

    var delegate: CurrenciesTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.delegate = ANSharedManager.sharedInstance.viewController!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = currencies[indexPath.row]

        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        if (delegate != nil) {
            self.delegate?.touchOccured(self.tableView.cellForRowAtIndexPath(indexPath)!)
//        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(__FUNCTION__)
    }

}
