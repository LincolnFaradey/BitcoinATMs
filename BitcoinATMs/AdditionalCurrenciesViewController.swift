//
//  AdditionalCurrenciesViewController.swift
//  BitcoinExchange
//
//  Created by Andrei Nechaev on 3/7/15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit

class AdditionalCurrenciesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    
    var value = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyPickerView.delegate = self
        self.addButton.layer.cornerRadius = 5.0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    
    //MARK: UIPickerViewDelegate methods
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return component == 0 ? symbols[row] : currencies[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currencyPickerView.selectRow(row, inComponent: 0, animated: true)
        self.currencyPickerView.selectRow(row, inComponent: 1, animated: true)
        self.currencyPickerView.selectRow(row, inComponent: 2, animated: true)
        value = row
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
        switch component {
        case 0, 1:
            let frame = CGRectMake(0, 0, 50, 50)
            let label = UILabel(frame: frame)
            label.font = UIFont(name: "HelveticaNeue-Thin", size: 22)
            label.text = component == 0 ? currencies[row] : symbols[row]
            return label
        default:
            let imgRect = CGRectMake(0, 0, 32, 24)
            let imageView = UIView()
            imageView.layer.contents = UIImage(named: "flags")?.CGImage
            imageView.layer.contentsRect = rectForFlag(value: flags_[row])
            imageView.layer.contentsGravity = kCAGravityResizeAspect
            imageView.layer.magnificationFilter = kCAFilterNearest
            return imageView
        }
    }
    
    @IBAction func addCurrency(sender: UIButton) {
        sender.tag = 111
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

}
