//
//  NSDate+Comparison.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

public extension NSDate {
    
    /**
     Checks if self is after input NSDate
     
     - parameter date: NSDate to compare
     - returns: True if self is after the input NSDate, false otherwise
     */
    public func isAfter(date: NSDate) -> Bool{
        return (self.compare(date) == NSComparisonResult.OrderedDescending)
    }
    
    /**
     Checks if self is before input NSDate
     
     - parameter date: NSDate to compare
     - returns: True if self is before the input NSDate, false otherwise
     */
    public func isBefore(date: NSDate) -> Bool{
        return (self.compare(date) == NSComparisonResult.OrderedAscending)
    }
    
    /**
     Today's Check
     
     - returns: true if today's date
     */
    public func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate())
    }
    
    /**
     Tomorrow's Check
     
     - returns: true if Tomorrow's date
     */
    public func isTomorrow() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate())
    }
    
    /**
     Yesterday's Check
     
     - returns: true if Yesterday's date
     */
    public func isYesterday() -> Bool {
        return self.isEqualToDateIgnoringTime(NSDate())
    }
    
    /**
     Compare dates ignoring time
     
     - returns: true if same day
     */
    public func isEqualToDateIgnoringTime(date: NSDate) -> Bool {
        
        let components1 = components()
        let components2 = date.components()
        
        return ((components1.year == components2.year) && (components1.month == components2.month) && (components1.day == components2.day))
        
    }
}