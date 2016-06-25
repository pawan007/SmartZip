//
//  NSDate+Additions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

public extension NSDate {
    
    // MARK:  NSDate Manipulation
    
    /**
        Returns a new NSDate object representing the date calculated by adding the amount specified to self date
    
        - parameter seconds: number of seconds to add
        - parameter minutes: number of minutes to add
        - parameter hours: number of hours to add
        - parameter days: number of days to add
        - parameter weeks: number of weeks to add
        - parameter months: number of months to add
        - parameter years: number of years to add
        - returns: the NSDate computed
    */
   public func add(seconds: Int = 0, minutes: Int = 0, hours: Int = 0, days: Int = 0, weeks: Int = 0, months: Int = 0, years: Int = 0) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
    
        let version = floor(NSFoundationVersionNumber)
    
        if version <= NSFoundationVersionNumber10_9_2 {
            var component = NSDateComponents()
            component.setValue(seconds, forComponent: .Second)
            
            var date : NSDate! = calendar.dateByAddingComponents(component, toDate: self, options: [])!
            component = NSDateComponents()
            component.setValue(minutes, forComponent: .Minute)
            date = calendar.dateByAddingComponents(component, toDate: date, options: [])!
            
            component = NSDateComponents()
            component.setValue(hours, forComponent: .Hour)
            date = calendar.dateByAddingComponents(component, toDate: date, options: [])!
            
            component = NSDateComponents()
            component.setValue(days, forComponent: .Day)
            date = calendar.dateByAddingComponents(component, toDate: date, options: [])!
            
            component = NSDateComponents()
            component.setValue(weeks, forComponent: .WeekOfMonth)
            date = calendar.dateByAddingComponents(component, toDate: date, options: [])!
            
            component = NSDateComponents()
            component.setValue(months, forComponent: .Month)
            date = calendar.dateByAddingComponents(component, toDate: date, options: [])!
            
            component = NSDateComponents()
            component.setValue(years, forComponent: .Year)
            date = calendar.dateByAddingComponents(component, toDate: date, options: [])!
            return date
        }
        
        var date : NSDate! = calendar.dateByAddingUnit(.Second, value: seconds, toDate: self, options: [])
        date = calendar.dateByAddingUnit(.Minute, value: minutes, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Day, value: days, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Hour, value: hours, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.WeekOfMonth, value: weeks, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Month, value: months, toDate: date, options: [])
        date = calendar.dateByAddingUnit(.Year, value: years, toDate: date, options: [])
        return date
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of seconds to self date
    
        - parameter seconds: number of seconds to add
        - returns: the NSDate computed
    */
    public func addSeconds (seconds: Int) -> NSDate {
        return add(seconds)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of minutes to self date
    
        - parameter minutes: number of minutes to add
        - returns: the NSDate computed
    */
    public func addMinutes (minutes: Int) -> NSDate {
        return add(minutes: minutes)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of hours to self date
    
        - parameter hours: number of hours to add
        - returns: the NSDate computed
    */
    public func addHours(hours: Int) -> NSDate {
        return add(hours: hours)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of days to self date
    
        - parameter days: number of days to add
        - returns: the NSDate computed
    */
    public func addDays(days: Int) -> NSDate {
        return add(days: days)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of weeks to self date
    
        - parameter weeks: number of weeks to add
        - returns: the NSDate computed
    */
    public func addWeeks(weeks: Int) -> NSDate {
        return add(weeks: weeks)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of months to self date
    
        - parameter months: number of months to add
        - returns: the NSDate computed
    */
    public func addMonths(months: Int) -> NSDate {
        return add(months: months)
    }
    
    /**
        Returns a new NSDate object representing the date calculated by adding an amount of years to self date
    
        - parameter years: number of year to add
        - returns: the NSDate computed
    */
    public func addYears(years: Int) -> NSDate {
        return add(years: years)
    }
    
    // MARK:- Class Functions
    /**
    Convert date from String
    
    - parameter dateStr: date String
    - parameter format:  date format
    
    - returns: Date object
    */
    public class func dateFromString(dateStr: String?, inout WithFormat format:String?) -> NSDate? {
        
        if dateStr == nil {
            return nil
        }
        if format == nil {
            format = NSDate.dateFormatDDMMYYYYDashed()
        }
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        
        return formatter.dateFromString(dateStr!)
    }
}

extension NSDate: Strideable {
    /**
     Get Time interval between to Date
     
     - parameter other: Other Date
     
     - returns: time distance
     */
    public func distanceTo(other: NSDate) -> NSTimeInterval {
        return other - self
    }
    
    /**
     Get date by timeIntervalSinceReferenceDate
     
     - parameter n: time interval
     
     - returns: Date object
     */
    public func advancedBy(n: NSTimeInterval) -> Self {
        return self.dynamicType.init(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate + n)
    }
}
