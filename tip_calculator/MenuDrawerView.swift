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
    var container: UICollisionBehavior!
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
    
    var controller : ViewController!
    
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

        self.controller.view.addGestureRecognizer(screenEdgePan)
        self.addGestureRecognizer(panGestureRecognizer)

        animator = UIDynamicAnimator(referenceView: self.superview!)
        dynamicItem = UIDynamicItemBehavior(items: [self])
        dynamicItem.allowsRotation = false
        dynamicItem.elasticity = 0
        
        gravity = UIGravityBehavior(items: [self])
//        gravity.gravityDirection = CGVectorMake(-1, 0)
        
        container = UICollisionBehavior(items: [self])
        
//        configureContainer()
        
//        animator.addBehavior(gravity)
        animator.addBehavior(dynamicItem)
//        animator.addBehavior(container)
        
    }
    
//    func configureContainer() {
//        let boundaryWidth = UIScreen.mainScreen().bounds.size.width
//        let boundaryHeight = UIScreen.mainScreen().bounds.size.height
////        print ("boundry width = \(boundaryWidth)")
////        print("boundru hieght = \(boundaryHeight)")
////        container.addBoundaryWithIdentifier("left", fromPoint: CGPointMake(boundaryWidth/2, 0), toPoint: CGPointMake(boundaryWidth, boundaryHeight))
////        container.addBoundaryWithIdentifier("right", fromPoint: CGPointMake(boundaryWidth, 0), toPoint: CGPointMake(boundaryWidth, boundaryHeight))
//    }
    

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
            animator.addBehavior(container)
//            snapToMid()
        }
        else {
            // Drag the frame around
            self.frame.origin.x = self.frame.origin.x + (velocity * 0.02)
//            animator.removeBehavior(snap)
//            snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)))
//            animator.addBehavior(snap)
        }
    
    }
    
    func panGestureEnded(velocity: CGFloat) {
        print ("in pan gesture ended&&&&&&&&&&&&&&&&")
//        animator.removeBehavior(snap)

//        let velocity = dynamicItem.linearVelocityForItem(self)
        print ("x FINAL velocity = \(velocity)")
        
        if velocity < 0 {
            controller.menuDrawerToggled = true
            controller.blackView.alpha = 0.5
            controller.addBlur()
            snapToMid()
        }
        else {
            controller.menuDrawerToggled = false
            controller.blackView.alpha = 0.0
            controller.hideblur()
            snapToRight()
        }

    }
    func snapToMid() {
        animator.removeAllBehaviors()
        // THE PROBLEM IS, THAT SNAP BEHAIVOR SNAPS MY VIEWS !!!!CENTER!!!1 TO THE SPECIFIED POINT... WOW.
        print("snapping mid lol ")
        gravity.gravityDirection = CGVectorMake(-2.5, 0)
        var xpos = ((self.superview?.bounds.width)! - widthOfElements())
        let halfOfWidth = self.frame.width/2
        print("half of width = \(halfOfWidth)")
        xpos += halfOfWidth
        print ("snap mid x pos: \(xpos)")
        snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(xpos, CGRectGetMidY(self.frame)))
        animator.addBehavior(snap)
    }
    func snapToRight() {
        animator.removeAllBehaviors()
        print("snapping right lol")
        gravity.gravityDirection = CGVectorMake(2.5, 0)
        
        var xpos = (self.superview?.bounds.width)! - 1
        let halfOfWidth = self.frame.width/2
        print("half of width = \(halfOfWidth)")
        xpos += halfOfWidth
        print ("snap right x pos: \(xpos)")
        
        snap = UISnapBehavior(item: self, snapToPoint: CGPointMake(xpos, CGRectGetMidY(self.frame)))
        animator.addBehavior(snap)
    }
    
    func configure(view:UIView, controller:ViewController) {
        self.frame = CGRectMake(view.frame.width - 1, view.frame.height, frame.width, frame.height*2.0)
        
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
