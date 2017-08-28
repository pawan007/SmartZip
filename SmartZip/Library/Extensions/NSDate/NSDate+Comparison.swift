//
//  NSDate+Comparison.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

public extension Date {
    
    /**
     Checks if self is after input NSDate
     
     - parameter date: NSDate to compare
     - returns: True if self is after the input NSDate, false otherwise
     */
    public func isAfter(_ date: Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedDescending)
    }
    
    /**
     Checks if self is before input NSDate
     
     - parameter date: NSDate to compare
     - returns: True if self is before the input NSDate, false otherwise
     */
    public func isBefore(_ date: Date) -> Bool{
        return (self.compare(date) == ComparisonResult.orderedAscending)
    }
    
    /**
     Today's Check
     
     - returns: true if today's date
     */
    public func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(Date())
    }
    
    /**
     Tomorrow's Check
     
     - returns: true if Tomorrow's date
     */
    public func isTomorrow() -> Bool {
        return self.isEqualToDateIgnoringTime(Date())
    }
    
    /**
     Yesterday's Check
     
     - returns: true if Yesterday's date
     */
    public func isYesterday() -> Bool {
        return self.isEqualToDateIgnoringTime(Date())
    }
    
    /**
     Compare dates ignoring time
     
     - returns: true if same day
     */
    public func isEqualToDateIgnoringTime(_ date: Date) -> Bool {
        
        let components1 = components()
        let components2 = date.components()
        
        return ((components1.year == components2.year) && (components1.month == components2.month) && (components1.day == components2.day))
        
    }
}
