//
//  ViewController.swift
//  BitcoinExchange
//
//  Created by Andrey on 15.02.15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit
//TODO: reachability!
class ViewController: UIViewController {
    var isLeftOnScreen = false;
    
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var leadingCellConstraint: NSLayoutConstraint!
    @IBOutlet var currencyCells: [UILabel]!
    
    @IBOutlet var middleConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var sideBar: UIView!
    
    @IBOutlet weak var sideBarHorizontalSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var showMenuButton: UIButton!
    
    @IBOutlet weak var showButtonLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceStateLabel: UILabel!
    
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet var flagPlaceholders: [UIImageView]!
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet var rowsLeftConstraints: [NSLayoutConstraint]!
    @IBOutlet var rowsRightConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var updatingLabel: UILabel!
    
    @IBOutlet weak var bottomBarView: UIView!
    
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewContainer: UIView!
    
    @IBOutlet weak var showTableView: UIButton!
    
    var displayLink: CADisplayLink?
    let timeCycle: Int = 60
    
    var isMenuInScreenRect: Bool = false
    var factor = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayLink = CADisplayLink(target: self, selector: Selector("animateCoin"))
        displayLink!.frameInterval = 60 * timeCycle
        
        self.setShadowFor(layer: sideBar.layer)
        
        for label in self.currencyCells {
            self.setShadowFor(layer: label.layer)
        }
        
        self.leadingCellConstraint.constant -= self.view.bounds.size.height
        self.sideBarHorizontalSpaceConstraint.constant -= self.view.bounds.size.width
        
        for constraint in self.middleConstraints {
            constraint.constant -= self.view.bounds.size.height
        }
        
        self.containerViewConstraint.constant -= self.view.bounds.size.width
        self.tableViewContainer.layer.zPosition = 100.0
        self.tableViewContainer.backgroundColor = UIColor(hue:0.574, saturation:0.690, brightness:0.910, alpha: 1)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        self.animateRows(1)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.animateRows(-1)
        self.showMenu(self.showMenuButton)
        
        displayLink!.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println(__FUNCTION__)
    }
    
    
    
    //MARK: Animation
    func animateRows(direction: CGFloat)
    {
        var delay:Double = 0.0
        
        UIView.animateWithDuration(1.0, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .CurveEaseIn, animations: { _ in
            delay = 0.1;
            self.leadingCellConstraint.constant += (self.view.bounds.size.height * direction)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        for constraint in self.middleConstraints {
            UIView.animateWithDuration(1.0, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .CurveEaseIn, animations: { _ in
                delay += 0.2;
                constraint.constant += (self.view.bounds.size.height * direction)
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateCoin()
    {
        self.updateUI()
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0/500.0
        
        UIView.animateKeyframesWithDuration(3.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModePaced, animations: { _ in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                self.coinImageView.layer.transform = perspective;
                self.coinImageView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_4), 0, 1, 0);
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                self.coinImageView.layer.transform = perspective;
                self.coinImageView.layer.transform = CATransform3DMakeRotation(CGFloat(-M_PI_4), 0, 1, 0);
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                self.coinImageView.layer.transform = perspective;
                self.coinImageView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
            })
            
        }, completion: nil)
    }
    
    func updateUI() {
        let currencyArray: [String] = ["USD", "EUR", "RUB"]
        let flagNumbers: [UInt8] = [228, 7, 193]
        
        for index in 0...(currencyArray.count - 1) {
            let label = self.currencyCells[index]
            
            ANDownloader.loadCurrency(currencyArray[index], handler: { (num: NSNumber) -> () in
                label.text = num.stringValue
                
                let imgView = self.flagPlaceholders[index]
                imgView.image = UIImage(named: "flags")
                let flagNum = Double(flagNumbers[index]) * 1.0 * 32.0 / (246.0 * 32.0)
                imgView.layer.contentsRect = CGRectMake(0, CGFloat(flagNum), 1.0, 1.0/246.0);
                
                imgView.layer.contentsGravity = kCAGravityResizeAspect;
                imgView.layer.magnificationFilter = kCAFilterNearest;
            })
            
            ANDownloader.getAveragePrice({ (avg: String) -> () in
                self.priceStateLabel.text = avg
                if contains(avg, "-") {
                    self.arrow.image = UIImage(named:"redArrow")
                }else {
                    self.arrow.image = UIImage(named:"blueArrow")
                }
            })
        }
        
        self.blink()
    }
    
    
    //MARK: IBActions
    @IBAction func showMenu(sender: UIButton) {
        
        if isLeftOnScreen {
            self.showTableView(self.showTableView)
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            sender.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4 + M_PI) * CGFloat(-self.factor))
            
            if self.factor == 1 {
                self.isMenuInScreenRect = true
                self.view.backgroundColor = UIColor(hue:0.564, saturation:0.242, brightness:0.631, alpha: 1)
                self.bottomBarView.backgroundColor = UIColor(hue:0.564, saturation:0.310, brightness:0.511, alpha: 1)
                self.showButtonLayoutConstraint.constant += self.sideBar.bounds.size.width;
                self.sideBarHorizontalSpaceConstraint.constant += self.view.bounds.size.width;
                self.moveRows(1)
            }else {
                self.isMenuInScreenRect = false
                self.view.backgroundColor = UIColor(hue:0.574, saturation:0.690, brightness:0.910, alpha: 1)
                self.bottomBarView.backgroundColor = UIColor(hue:0.565, saturation:0.471, brightness:0.341, alpha: 1)
                self.showButtonLayoutConstraint.constant -= self.sideBar.bounds.size.width;
                self.sideBarHorizontalSpaceConstraint.constant -= self.view.bounds.size.width;
                self.moveRows(-1)
            }
            
            self.view.layoutIfNeeded()
        })
        
        self.factor = factor == 1 ? 0 : 1
    }
    
    @IBAction func unwindToSegue(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func showTableView(sender: UIButton) {
        if !isLeftOnScreen {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.containerViewConstraint.constant += self.view.bounds.size.width
                self.moveRows(-1)
                self.view.layoutIfNeeded()
            })
        
            if isMenuInScreenRect { self.showMenu(self.showMenuButton) }
            isLeftOnScreen = true
        }else {

            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.containerViewConstraint.constant -= self.view.bounds.size.width
                self.moveRows(1)
                self.view.layoutIfNeeded()
            })
            isLeftOnScreen = false
            
        }
        
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if isMenuInScreenRect { self.showMenu(self.showMenuButton) }
        
        if isLeftOnScreen { self.showTableView(self.showTableView) }
    }
    
    
    //MARK: Helpers
    func moveRows(direction: CGFloat) {
        var delay:Double = 0.1
        
        for constraint in self.rowsLeftConstraints {
            delay += 1.0;
            UIView.animateWithDuration(0.7, delay: delay, options:.CurveEaseIn, animations: { () -> Void in
                constraint.constant += (self.sideBar.bounds.size.width * direction)
            }, completion: nil)
        }
        
        for constraint in self.rowsRightConstraints {
            
            UIView.animateWithDuration(0.7, delay: delay, options:.CurveEaseIn, animations: { () -> Void in
                constraint.constant -= (self.sideBar.bounds.size.width * direction)
                }, completion: nil)
            
        }
    }
    
    func blink() {
        UIView.animateKeyframesWithDuration(3.0, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModePaced, animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                self.updatingLabel.alpha = 1.0
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                self.updatingLabel.alpha = 0.2
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                self.updatingLabel.alpha = 1.0
            })
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.0, animations: { () -> Void in
                self.updatingLabel.alpha = 0.0
            })
            
            }, completion: nil)
    }
    
    func setShadowFor(#layer: CALayer) {
        layer.shadowColor = UIColor(hue:0.565, saturation:0.471, brightness:0.341, alpha: 1).CGColor
        layer.shadowOffset = CGSizeMake(2, 2)
        layer.shadowOpacity = 3.0;
        layer.shadowRadius = 1.5;
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchedView = touch.view
        
        //        if touchedView.isKindOfClass(UITableViewCell) {
        println(__FUNCTION__)
        //        }
    }

}


