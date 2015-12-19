//
//  MenuDrawerView.swift
//  tip_calculator
//
//  Created by Sergio Puleri on 12/18/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

import UIKit

class MenuDrawerView: UIView {

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recentsButton: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var controller : ViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    
    func configure(view:UIView, controller:ViewController) {
        self.frame = CGRectMake(view.frame.width, view.frame.height, widthOfElements(), frame.height*2.0)
        self.controller = controller
        
    }
    
    func widthOfElements() -> CGFloat {
        let width = recentsButton.frame.origin.x + recentsButton.frame.width + 50
        return width        
    }
    
    @IBAction func recentTotalsClicked(sender: AnyObject) {
        self.controller.recentTotalsButtonClicked()
    }
    
    @IBAction func settingsClicked(sender: AnyObject) {
        self.controller.settingsButtonClicked()
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.controller.cancelButtonClicked()
    }

}
