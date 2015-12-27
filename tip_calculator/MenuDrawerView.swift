//
//  MenuDrawerView.swift
//  tip_calculator
//
//  Created by Sergio Puleri on 12/18/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

import UIKit

// VIDEO: https://www.youtube.com/watch?v=hbuL-vUDBhg

class MenuDrawerView: UIView, UIGestureRecognizerDelegate {
    // Outlets
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var recentsButton: UIButton!
    
    // Properties
    var animator: UIDynamicAnimator!
    var snap: UISnapBehavior!
    var dynamicItem: UIDynamicItemBehavior!
    var gravity: UIGravityBehavior!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var screenEdgePan: UIScreenEdgePanGestureRecognizer!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var parent : ViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func setupPhysics() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGestureRecognizer.cancelsTouchesInView = false
        
        screenEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: "handlePan:")
        screenEdgePan.edges = .Right
        
        screenEdgePan.delegate = self
        screenEdgePan.cancelsTouchesInView = false

        self.parent.view.addGestureRecognizer(screenEdgePan)
        self.addGestureRecognizer(panGestureRecognizer)

        animator = UIDynamicAnimator(referenceView: self.superview!)
        dynamicItem = UIDynamicItemBehavior(items: [self])
        dynamicItem.allowsRotation = false
        dynamicItem.elasticity = 0
        
        gravity = UIGravityBehavior(items: [self])
        
        
        animator.addBehavior(dynamicItem)
        
    }
    


    func handlePan(pan: UIPanGestureRecognizer){
        // Remove all behaviors
        animator.removeAllBehaviors()
        let velocity = pan.velocityInView(self.superview).x
        print ("x velocity = \(velocity)")
        
        
        
        if pan.state == .Ended {
            panGestureEnded(velocity)
        }
        else if pan.state == .Began {
            animator.addBehavior(dynamicItem)
        }
        else {
            // Drag the frame around
            self.frame.origin.x = self.frame.origin.x + (velocity * 0.02)
        }
    
    }
    
    func panGestureEnded(velocity: CGFloat) {
        print ("x FINAL velocity = \(velocity)")
        
        if velocity < 0 {
            parent.menuDrawerToggled = true
            parent.blackView.alpha = 0.5
            parent.addBlur()
            snapToMid()
        }
        else {
            parent.menuDrawerToggled = false
            parent.blackView.alpha = 0.0
            parent.hideblur()
            snapToRight()
        }

    }
    
    // Snap behavior snaps the views center to the specified point..
    func snapToMid() {
        animator.removeAllBehaviors()
        gravity.gravityDirection = CGVectorMake(-2.5, 0)
        var xpos = ((self.superview?.bounds.width)! - widthOfElements())
        let halfOfWidth = self.frame.width/2
        xpos += halfOfWidth
        snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(xpos, CGRectGetMidY(self.frame)))
        snap.damping = 0.6
        animator.addBehavior(snap)
    }
    func snapToRight() {
        animator.removeAllBehaviors()
        gravity.gravityDirection = CGVectorMake(2.5, 0)
        var xpos = (self.superview?.bounds.width)! - 1
        let halfOfWidth = self.frame.width/2
        xpos += halfOfWidth
        
        snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(xpos, CGRectGetMidY(self.frame)))
        snap.damping = 0.6
        animator.addBehavior(snap)
    }
    
    func configure(view:UIView, parent:ViewController) {
        self.frame = CGRectMake(view.frame.width - 1, view.frame.height, frame.width, frame.height*2.0)
        self.parent = parent
    }
    
    
    func widthOfElements() -> CGFloat {
        let width = recentsButton.frame.origin.x + recentsButton.frame.width + 50
        return width        
    }
    
    @IBAction func recentTotalsClicked(sender: AnyObject) {
        self.parent.recentTotalsButtonClicked()
    }
    
    @IBAction func settingsClicked(sender: AnyObject) {
        self.parent.settingsButtonClicked()
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.parent.cancelButtonClicked()
    }

}
