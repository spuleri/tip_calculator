//
//  SettingsViewController.swift
//  tip_calculator
//
//  Created by Sergio Puleri on 12/18/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // Outlets
    @IBOutlet weak var saveTotalsSwitch: UISwitch!
    @IBOutlet weak var presetTipSwitch: UISwitch!
    
    // Settings
    var tipPercent : Int!
    var presetTipPercent = false
    var saveTotals = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let prefs = NSUserDefaults.standardUserDefaults()
        // Load preset tip setting
        let presetTipPercentSetting = prefs.boolForKey("presetTip")
        print("Tip percent setting: \(presetTipPercentSetting)")
        
        self.presetTipPercent = presetTipPercentSetting
        // If preset tip perecnt is true, get the saved preset percent and hide slider
        if self.presetTipPercent {
            self.tipPercent = prefs.integerForKey("tipPercent")
            //self.tipSlider.hidden = true
        }
        
        // Load save totals setting
        let saveTotalsSetting = prefs.boolForKey("saveTotals")
        print("Save totals setting: \(saveTotalsSetting)")
        self.saveTotals = saveTotalsSetting
        // Configure Switches
        self.saveTotalsSwitch.setOn(self.saveTotals, animated: true)
        self.presetTipSwitch.setOn(self.presetTipPercent, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTotalSwitchToggled(sender: AnyObject) {
        let uiswitch = sender as! UISwitch
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setBool(uiswitch.on, forKey: "saveTotals")
    }

    @IBAction func presetTipSwitchToggled(sender: AnyObject) {
        let uiswitch = sender as! UISwitch
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setBool(uiswitch.on, forKey: "presetTip")
        if uiswitch.on {
            print("i want a custom totalzz")
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
