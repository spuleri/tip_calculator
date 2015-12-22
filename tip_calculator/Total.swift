//
//  Total.swift
//  tip_calculator
//
//  Created by Sergio Puleri on 12/19/15.
//  Copyright © 2015 Sergio Puleri. All rights reserved.
//

import Foundation

// Model for a "Total" object
// Essentially a 'resturaunt visit'
class Total : NSObject, NSCoding {
    
    var bill       : Double = 0.0
    var tipPercent : Int    = 0
    var tip        : Double = 0.0
    var total      : Double = 0.0
    var date       : NSDate = NSDate()
    
    init (bill: Double, tipPercent: Int, tip: Double, total: Double, date: NSDate){
        self.bill = bill
        self.tipPercent = tipPercent
        self.tip = tip
        self.total = total
        self.date = date
    }
    

    
    required init(coder aDecoder: NSCoder) {
        bill = aDecoder.decodeObjectForKey("bill") as! Double
        tipPercent = aDecoder.decodeObjectForKey("tipPercent") as! Int
        tip = aDecoder.decodeObjectForKey("tip") as! Double
        total = aDecoder.decodeObjectForKey("total") as! Double
        date = aDecoder.decodeObjectForKey("date") as! NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(bill, forKey: "bill")
        aCoder.encodeObject(tipPercent, forKey: "tipPercent")
        aCoder.encodeObject(tip, forKey: "tip")
        aCoder.encodeObject(total, forKey: "total")
        aCoder.encodeObject(date, forKey: "date")

        
    }
}