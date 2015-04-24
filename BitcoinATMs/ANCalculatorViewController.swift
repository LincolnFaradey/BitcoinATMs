//
//  ANCalculatorViewController.swift
//  BitcoinATMs
//
//  Created by Andrei Nechaev on 4/13/15.
//  Copyright (c) 2015 Andrei Nechaev. All rights reserved.
//

import UIKit

class ANCalculatorViewController: UIViewController {

    @IBOutlet var calcDisplay: UILabel!
    var value: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func numberWasPressed(sender: UIButton) {
        if count(calcDisplay.text!) < 10 {
            value += toString(sender.tag - 100)
            calcDisplay.text! = toString(NSDecimalNumber(string: value).doubleValue / 100.0)
        }
    }

    @IBAction func operatorButtonWasPressed(sender: UIButton) {
        println(__FUNCTION__)
    }
}
