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
        }
        
        totalLabel.text = "$0.00"
        configureBlur()
        configureBlackView()
        configureMenuDrawerView()
    }
    
    // Settings are loaded in view will appear since we want to reload them when coming back from the settings page.
    override func viewWillAppear(animated: Bool) {
        
        let prefs = NSUserDefaults.standardUserDefaults()

        // Load preset tip setting
        let presetTipPercentSetting = prefs.boolForKey("presetTip")
        print("Tip percent setting: \(presetTipPercentSetting)")
        
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
        print("Save totals setting: \(saveTotalsSetting)")
        self.saveTotals = saveTotalsSetting
        
        // Set tip percent label
        tipPercentLabel.text = "\(self.tipPercent)%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
//        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismissAddPollView")
//        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
//        self.menuDrawerView.addGestureRecognizer(swipeDown)
    }
    
    func showMenuDrawerView() {
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: {
            var viewFrame = self.menuDrawerView.frame
            viewFrame.origin.x = self.view.frame.size.width - viewFrame.size.width
            self.menuDrawerView.frame = viewFrame
            self.blackView.alpha = 0.5
            }, completion: { finished in })
    }
    func hideMenuDrawerView() {
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: .CurveEaseInOut, animations: {
            var viewFrame = self.menuDrawerView.frame
            viewFrame.origin.x = self.view.frame.size.width
            self.menuDrawerView.frame = viewFrame
             self.blackView.alpha = 0.0
            }, completion: { finished in })
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
        let blurEffect = UIBlurEffect(style: .Light)
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
    
    func calculateTip(){
        let billAmount = (billTextField.text! as NSString).doubleValue
        let tip = billAmount * Double(tipPercent)/100.0
        let total = billAmount + tip
        tipAmountLabel.text = String(format: "$%.2f", arguments: [tip])
        totalLabel.text = String(format: "$%.2f", arguments: [total])
    }
    
    func cancelButtonClicked() {
        self.menuButtonClicked(self)
        
    }
    
    func settingsButtonClicked() {
        performSegueWithIdentifier("showSettings", sender: self)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettings" {
            self.settingsVC = segue.destinationViewController as! SettingsViewController
        }
    }
    func recentTotalsButtonClicked() {
        
    }
}

