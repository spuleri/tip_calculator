//
//  ViewController.swift
//  tip_calculator
//
//  Created by Sergio Puleri on 12/17/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var tipPercentLabelLabel: UILabel!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var totalLabel: UILabel!
    
    // Class Properties
    // Tip Percent defaults to 15%
    var tipPercent = 15
    var settingsVC : SettingsViewController!
    var menuDrawerView : MenuDrawerView!
    var menuDrawerToggled = false
    var blackView : UIView!
    var blurredEffectView : UIVisualEffectView!
    var totals : [Total] = []
    
    // Settings
    var presetTipPercent = false
    var saveTotals = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let prefs = NSUserDefaults.standardUserDefaults()
        
        // Check if first launch
        let firstLaunchSetting = prefs.boolForKey("notFirstLaunch")
        if !firstLaunchSetting {
            print("is first launch")
            // Set settings on first launch
            prefs.setBool(true, forKey: "notFirstLaunch")
            prefs.setBool(true, forKey: "saveTotals")
            prefs.setBool(false, forKey: "presetTip")
            // Set empty mutable array to hold recent totals
            prefs.setObject([], forKey: "recentTotals")
        }
        
        // TODO: make sure loading from NSUserDefaults works
        // Load array of recent totals in viewDidLoad from NSUserDefaults
        if let savedTotals = prefs.objectForKey("recentTotals") as? NSData {
            self.totals = NSKeyedUnarchiver.unarchiveObjectWithData(savedTotals) as! [Total]
        }
        print ("Theere are \(self.totals.count) totals")
        for t in self.totals {
            print("Total: \(t.total)")
            print ("Date: \(t.date)")
        }
        
        


        totalLabel.text = "$0.00"
        configureBlur()
        configureBlackView()
        configureMenuDrawerView()
        
        // Create background gradient
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(red:0.24, green:0.52, blue:0.66, alpha:1.0).CGColor,UIColor(red:0.27, green:0.80, blue:0.81, alpha:1.0).CGColor, UIColor(red:0.67, green:0.93, blue:0.85, alpha:1.0).CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    // Settings are loaded in view will appear since we want to reload them when coming back from the settings page.
    override func viewWillAppear(animated: Bool) {
        
        // Hide blur whenever view appears in case it was active
        hideblur()
        
        // Set text field as first responder to set focus to it whenever view appears
        billTextField.becomeFirstResponder()
        
        let prefs = NSUserDefaults.standardUserDefaults()

        // Load preset tip setting
        let presetTipPercentSetting = prefs.boolForKey("presetTip")
        self.presetTipPercent = presetTipPercentSetting
        // If preset tip perecnt is true, get the saved preset percent and hide slider
        if self.presetTipPercent {
            self.tipPercent = prefs.integerForKey("tipPercent")
            self.tipSlider.hidden = true
            self.tipPercentLabelLabel.hidden = false
        }
        else {
            self.tipSlider.hidden = false
            self.tipPercentLabelLabel.hidden = true
        }
        
        // Load save totals setting
        let saveTotalsSetting = prefs.boolForKey("saveTotals")
        self.saveTotals = saveTotalsSetting
        
        // Set tip percent label
        tipPercentLabel.text = "\(self.tipPercent)%"
    }
    
    override func viewDidLayoutSubviews() {
        // Needs to be done in here cuz of some SO thread that says so if im using auto-layout
        configureTextView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTextView() {
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, self.billTextField.frame.size.height-1, self.billTextField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.whiteColor().CGColor
        self.billTextField.borderStyle = .None
        self.billTextField.layer.addSublayer(bottomBorder)
        self.billTextField.returnKeyType = .Done

    }
    
    func configureBlackView() {
        // Create view to cover the screen when menu drawer is active
        self.blackView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.blackView.backgroundColor = UIColor.blackColor()
        self.blackView.alpha = 0.0
        self.view.addSubview(blackView)
    }
    
    func configureMenuDrawerView() {
        menuDrawerView = NSBundle.mainBundle().loadNibNamed("MenuDrawerView", owner: self, options: nil)[0] as? MenuDrawerView
        let navBarView = self.navigationController?.navigationBar
        menuDrawerView.configure(navBarView!, controller: self)
        self.view.addSubview(menuDrawerView)
        menuDrawerView.setupPhysics()
    }
    
    func showMenuDrawerView() {
        self.menuDrawerView.snapToMid()
        self.blackView.alpha = 0.5
        
//        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: {
////            var viewFrame = self.menuDrawerView.frame
//            self.menuDrawerView.frame.origin.x = self.view.frame.size.width - self.menuDrawerView.widthOfElements()
////            self.menuDrawerView.frame = viewFrame
//            self.blackView.alpha = 0.5
//            }, completion: { finished in })
    }
    func hideMenuDrawerView() {
        self.menuDrawerView.snapToRight()
        self.blackView.alpha = 0.0
        
//        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: {
////            var viewFrame = self.menuDrawerView.frame
//            self.menuDrawerView.frame.origin.x = self.view.frame.size.width
////            self.menuDrawerView.frame = viewFrame
//             self.blackView.alpha = 0.0
//            }, completion: { finished in })
    }
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        if (!menuDrawerToggled){
            menuDrawerToggled = true
            showMenuDrawerView()
            addBlur()
        }
        else {
            menuDrawerToggled = false
            hideMenuDrawerView()
            hideblur()
        }
        
    }
    func configureBlur() {
        let blurEffect = UIBlurEffect(style: .Dark)
        self.blurredEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurredEffectView.frame = self.view.bounds
        self.blurredEffectView.alpha = 0.6
        
        let tapBlurView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuButtonClicked:")
        self.blurredEffectView.addGestureRecognizer(tapBlurView)
    }
    func addBlur() {
        self.view.insertSubview(self.blurredEffectView, belowSubview: self.menuDrawerView)
    }
    func hideblur() {
        self.blurredEffectView.removeFromSuperview()
        
    }

    @IBAction func onNewBillAmount(sender: AnyObject) {
        calculateTip()
    }

    @IBAction func sliderValueChanged(sender: AnyObject) {
        // Cast sender to UISlider and get value and cast as Int
        let currentValue = Int((sender as! UISlider).value)
        tipPercent = currentValue
        tipPercentLabel.text = "\(tipPercent)%"
        calculateTip()
        
    }
    @IBAction func onTapToDismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func timerFireMethod(total: Total) {
        print(total.total)
        let totalLabelValue = ((self.totalLabel.text! as NSString).stringByReplacingOccurrencesOfString("$", withString: "") as NSString).doubleValue
        if total.total == totalLabelValue {
            print("same, gonna save")
            saveTotal(total)
        }
    }
    func saveTotal(total: Total) {
        self.totals.append(total)
        let prefs = NSUserDefaults.standardUserDefaults()
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.totals) as NSData
        prefs.setObject(data, forKey: "recentTotals")
        print("Saved a total")
        print ("self.totals size is \(self.totals.count)")
    }
    
    func calculateTip(){
        let billAmount = (billTextField.text! as NSString).doubleValue
        let tip = billAmount * Double(tipPercent)/100.0
        let total = billAmount + tip
        tipAmountLabel.text = String(format: "$%.2f", arguments: [tip])
        totalLabel.text = String(format: "$%.2f", arguments: [total])
        
        // Create total object
        let currentTotal = Total(bill: billAmount, tipPercent: tipPercent, tip: tip, total: total, date: NSDate())
        // Only want to save if a total is unchanged after ~6sec. If someone is sliding the slider around, we dont want to save a bunch of totals.
        self.performSelector("timerFireMethod:", withObject: currentTotal, afterDelay: 6.0)
        
    }
    
    func cancelButtonClicked() {
        self.menuButtonClicked(self)
        
    }
    
    func settingsButtonClicked() {
        menuButtonClicked(self)
        performSegueWithIdentifier("showSettings", sender: self)
        
    }
    // ModalVC: Transparent BG -> http://stackoverflow.com/a/33122882/3590748
    func recentTotalsButtonClicked() {
        menuButtonClicked(self)
        addBlur()
        performSegueWithIdentifier("showRecents", sender: self)        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRecents" {
            // Set "parentVC" property of RecentsTableVC to self, in order to call methods from here
            let nav = segue.destinationViewController as! UINavigationController
            let recentsVC = nav.topViewController as! RecentsTableViewController
            recentsVC.parentVC = self
            // Send reverse of totals array, so Recents VC gets most recent first
            recentsVC.totals = self.totals.reverse()
        }
    }
}

