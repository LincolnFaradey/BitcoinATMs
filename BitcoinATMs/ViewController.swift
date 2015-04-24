//
//  ViewController.swift
//  BitcoinExchange
//
//  Created by Andrey on 15.02.15.
//  Copyright (c) 2015 Andrei. All rights reserved.
//

import UIKit
//TODO: reachability!
class ViewController: UIViewController, CurrenciesTableViewDelegate {
    @IBOutlet var userSymbols: [UILabel]!
    
    var userData: [Int] = [1, 2, 3]
    
    var isLeftOnScreen = false;
    
    @IBOutlet var currencyCodes: [UILabel]!
    
    
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
    
    @IBOutlet weak var showTableViewButton: UIButton!
    
    var comingView: UILabel?
    
    var animator: UIDynamicAnimator!
    
    var displayLink: CADisplayLink?
    let timeCycle: Int = 60
    
    var isMenuInScreenRect: Bool = false
    var factor = 1
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        ANSharedManager.sharedInstance.viewController = self
        
        displayLink = CADisplayLink(target: self, selector: Selector("animateCoin"))
        displayLink!.frameInterval = 60 * timeCycle
        
        self.updateData()
        self.prepareUI()
        
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
        self.updatePrices()
        
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
    
    func updatePrices() {
        
        for index in 0...(userData.count - 1) {
            let label = self.currencyCells[index]
            
            ANDownloader.loadCurrency(currencies[userData[index]], handler: { (num: NSNumber) -> () in
                label.text = NSString().stringByAppendingFormat("%.2f", num.doubleValue) as String
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
            self.showTableView(self.showTableViewButton)
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
        self.showTableView()
    }
    
    func showTableView() {
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
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if isMenuInScreenRect { self.showMenu(self.showMenuButton) }
        if isLeftOnScreen { self.showTableView(self.showTableViewButton) }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        animator.removeAllBehaviors()
        if comingView != nil {
            
            let snap = UISnapBehavior(item: comingView!, snapToPoint: (touches.first as! UITouch).locationInView(self.view))
            animator.addBehavior(snap)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.comingView?.removeFromSuperview()
        if comingView != nil {
            let curIndex = find(currencies, comingView!.text!)
            let touch = touches.first as! UITouch
            let point = touch.locationInView(self.view)
            
            for cell in currencyCells {
                if cell.frame.contains(point) && !contains(userData, curIndex!) {
                    userData[cell.tag - 1000] = curIndex!
                    
                    userDefaults.setValue(userData, forKey: "userData")
                    userDefaults.synchronize()
                    self.updateData()
                    self.updatePrices()
                    self.view.setNeedsDisplay()
                    break
                }
            }
            
        }
        
        comingView = nil
    }
    
    func touchOccured(theView: UITableViewCell) {
        self.showTableView()
        self.view.becomeFirstResponder()
        let rect = CGRectMake(theView.frame.origin.x, theView.frame.origin.y, theView.frame.width, 40)
        comingView = UILabel(frame: rect)
        
        comingView!.alpha = 0.8
        comingView!.backgroundColor = UIColor(hue:0.565, saturation:0.471, brightness:0.341, alpha: 1)
        comingView!.font = UIFont(name: "HelveticaNeue-Thin", size: 36)
        comingView!.textAlignment = NSTextAlignment.Center
        comingView!.textColor = UIColor.whiteColor()
        comingView!.text = theView.textLabel?.text
        comingView!.frame.origin.x = self.view.frame.width - comingView!.frame.width
        comingView!.frame.origin.y = self.tableViewContainer.frame.height / 2
 
        self.view.addSubview(comingView!)
        
        func delay(delay:Double, closure:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(delay * Double(NSEC_PER_SEC))
                ),
                dispatch_get_main_queue(), closure)
        }
        
        delay(4.0, { () -> () in
            if self.comingView != nil {
                self.comingView?.removeFromSuperview()
            }
        });
    }

    func updateData() {
        let data: AnyObject? = userDefaults.valueForKey("userData")
        
        if data != nil { userData = data as! [Int] }
        
        for index in 0...(userData.count - 1) {
            currencyCodes[index].text = currencies[userData[index]]
            let imgView = self.flagPlaceholders[index]
            imgView.image = UIImage(named: "flags")
            
            let flagNum = Double(flags_[userData[index]]) * 1.0 * 32.0 / (246.0 * 32.0)
            imgView.layer.contentsRect = CGRectMake(0, CGFloat(flagNum), 1.0, 1.0/246.0)
            imgView.layer.contentsGravity = kCAGravityResizeAspect
            imgView.layer.magnificationFilter = kCAFilterNearest
            
            userSymbols[index].text = symbols[userData[index]]
        }
        
        ANSharedManager.sharedInstance.sharedIndexes = userData
    }
    
    func prepareUI() {
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
}


