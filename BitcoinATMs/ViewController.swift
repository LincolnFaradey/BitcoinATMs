//
//  ViewController.swift
//  BitcoinExchange
//
//  Created by Andrey on 15.02.15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit
//TODO: reachability!
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    var isCalculating = false
    
    @IBOutlet weak var currencyPrice: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var avergPriceLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!

    @IBOutlet weak var currencyCalculatorTextField: UITextField!
    @IBOutlet weak var currencyCalculatorLabel: UILabel!
    
    @IBOutlet weak var calcWidthConstraint: NSLayoutConstraint!
    
    var thePrice: NSNumber = 0.0
    
    var values: [Int] = [149]
    
    let colors: [UIColor] = [
        UIColor(hue:0.565, saturation:0.870, brightness:1, alpha: 1),
        UIColor(hue:0.500, saturation:0.745, brightness:0.7, alpha: 1),
        UIColor(hue:0.599, saturation:0.813, brightness:0.988, alpha: 1)
    ]
    var currencySym: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        let array = userDefaults.objectForKey("Values") as? [Int]
        if array?.count > 0 {
            values = array!
        }
        let val = values[0]
        self.getPrice(currencies[val])
        self.view.backgroundColor = colors[0]
        self.currencySym = symbols[val]
        
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
        self.currencyCalculatorTextField.delegate = self
        self.currencyCalculatorTextField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)
        hideViewFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.avergPriceLabel.addObserver(self, forKeyPath: "text", options: .New, context: nil)
        showFields()
        self.currencyPicker.reloadAllComponents()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        self.avergPriceLabel.alpha = 0.0
        if (keyPath == "text"){
            UIView.animateWithDuration(0.8, delay: 0.3, options:.CurveEaseIn, animations: { () -> Void in
                self.avergPriceLabel.alpha = 1.0
            }, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    // MARK: main()
    
    func getPrice(currency: String!) {
        
        let request = NSURLRequest(URL: url!.URLByAppendingPathComponent(currency))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error:NSError!) -> Void in
            if ((data) != nil) {
            let JSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error:nil) as!NSDictionary
            self.thePrice = JSON["ask"] as! NSNumber
                
            if  self.thePrice != 0.0 {
                self.currencyPrice.text = self.currencySym + " " + (NSString().stringByAppendingFormat("%.2f", self.thePrice.doubleValue) as String)
                let avg = JSON["24h_avg"] as? NSNumber;
                if (avg != nil) {
                    self.avergPriceLabel.text = self.currencySym + avg!.stringValue
                }
            }
            }else {
                let alertViewController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let alertDefaultAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.Default, handler: { _ in
                    self.getPrice(currency)
                })
                let alertCancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { _ in
                })
                alertViewController.addAction(alertDefaultAction)
                alertViewController.addAction(alertCancelAction)
                self.presentViewController(alertViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: UIPickerViewDataSource, UIPickerViewDelegate methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.getPrice(currencies[values[row]])
        self.currencySym = symbols[values[row]]
        self.currencyPrice.alpha = 0.0
        UIView.animateWithDuration(0.8) { () -> Void in
            self.currencyPrice.alpha = 1.0
            self.view.backgroundColor = self.colors[row % self.colors.count]
        }
        pickerView.selectRow(row, inComponent: 0, animated: true)
        pickerView.selectRow(row, inComponent: 1, animated: true)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return currencies[values[row]]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        var frame = CGRectMake(0, 0, 32, 32)
        if component == 0 {
            let imgRect = CGRectMake(0, 0, 32, 24)
            let imageView = UIView()
            imageView.layer.contents = UIImage(named: "flags")?.CGImage
            imageView.layer.contentsRect = rectForFlag(value: flags_[values[row]])
            imageView.layer.contentsGravity = kCAGravityResizeAspect
            imageView.layer.magnificationFilter = kCAFilterNearest
            return imageView
        }
        frame = CGRectMake(0, 0, 60, 60)
        let myView  = UILabel(frame: frame)
        myView.text = currencies[values[row]]
        myView.font = UIFont(name: "HelveticaNeue-Thin", size: 22)
        myView.textColor = UIColor.whiteColor()
        return myView
    }
    
    
    //MARK: Helper methods
    
    func hideViewFields() {
        self.currencyPrice.center.x += self.view.bounds.width
        self.currencyPicker.alpha = 0.0
        self.currencyPrice.alpha = 0.0
        self.avergPriceLabel.alpha = 0.0
        
        self.currencyCalculatorTextField.alpha = 0.0
        self.currencyCalculatorLabel.alpha = 0.0
        self.currencyCalculatorTextField.backgroundColor = self.view.backgroundColor
    }
    
    func showFields() {
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.currencyPrice.center.x -= self.view.bounds.width
            self.currencyPrice.alpha = 1.0
            self.currencyPicker.alpha = 1.0
            
            self.currencyCalculatorTextField.alpha = 1.0
            self.currencyCalculatorTextField.backgroundColor = UIColor.whiteColor()
        })
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldDidChange(sender: UITextField) {
        self.currencyCalculatorLabel.text = self.currencySym + " " + (NSString().stringByAppendingFormat("%.2f", self.thePrice.doubleValue * NSString(string: sender.text).doubleValue) as String)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if !currencyCalculatorTextField.text.isEmpty {
                self.textFieldDidChange(self.currencyCalculatorTextField);
        }
        if (self.currencyCalculatorLabel.text! as NSString).localizedCaseInsensitiveContainsString("nan") || self.currencyCalculatorTextField.text.isEmpty{
            self.currencyCalculatorLabel.text = "0.0"
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.currencyPicker.alpha = 0.0
            self.currencyPrice.alpha = 0.0
            self.bitcoinLabel.alpha = 0.0
            self.addButton.alpha = 0.0
            self.currencyCalculatorLabel.alpha = 1.0
            self.removeButton.alpha = 0.0
            
            self.calcWidthConstraint.constant = self.view.bounds.width - 32
            self.view.layoutIfNeeded()
        })
        
        isCalculating = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !isCalculating { return }
        
        self.currencyCalculatorTextField.resignFirstResponder()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.currencyPicker.alpha = 1.0
            self.currencyPrice.alpha = 1.0
            self.bitcoinLabel.alpha = 1.0
            self.addButton.alpha = 1.0
            self.currencyCalculatorLabel.alpha = 0.0
            self.removeButton.alpha = 1.0
            
            self.calcWidthConstraint.constant = self.view.bounds.width / 2 - 16
            self.view.layoutIfNeeded()
        })
        
        isCalculating = false
    }
    
    //MARK: IBActions
    @IBAction func removeElement(sender: UIButton) {
        let index = self.currencyPicker.selectedRowInComponent(0)
        self.getPrice(currencies[values[self.currencyPicker.selectedRowInComponent(0)]])
        if values.count > 1 { values.removeAtIndex(index) }
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(self.values, forKey: "Values")
        self.currencyPicker.reloadAllComponents()
        
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
    }
    
    //MARK: Memory warnings
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println(__FUNCTION__)
    }
}

