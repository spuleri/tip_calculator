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
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var totalLabel: UILabel!
    
    // Class Properties
    // Tip Percent defaults to 15%
    var tipPercent = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipPercentLabel.text = "15%"
        totalLabel.text = "$0.00"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

