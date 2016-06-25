//
//  NSDate+Components.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
public extension NSDate {
    
    // MARK: Getter
    
    /**
    Date year
    */
    public var year : Int {
        get {
            return getComponent(.Year)
        }
    }
    
    /**
     Date month
     */
    public var month : Int {
        get {
            return getComponent(.Month)
        }
    }
    
    /**
     Date weekday
     */
    public var weekday : Int {
        get {
            return getComponent(.Weekday)
        }
    }
    
    /**
     Date weekMonth
     */
    public var weekMonth : Int {
        get {
            return getComponent(.WeekOfMonth)
        }
    }
    
    /**
     Date days
     */
    public var days : Int {
        get {
            return getComponent(.Day)
        }
    }
    
    /**
     Date hours
     */
    public var hours : Int {
        
        get {
            return getComponent(.Hour)
        }
    }
    
    /**
     Date minuts
     */
    public var minutes : Int {
        get {
            return getComponent(.Minute)
        }
    }
    
    /**
     Date seconds
     */
    public var seconds : Int {
        get {
            return getComponent(.Second)
        }
    }
    
    /**
     Returns the value of the NSDate component
     
     - parameter component: NSCalendarUnit
     - returns: the value of the component
     */
    
    public func getComponent (component : NSCalendarUnit) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(component, fromDate: self)
        
        return components.valueForComponent(component)
    }
    /**
     Returns the value of the NSDate component
     
     - returns: the value of the component
     */
    public func components() -> NSDateComponents {
        return NSCalendar.currentCalendar().components([.Era, .Year, .Month, .WeekOfYear, .WeekOfMonth, .Weekday, .WeekdayOrdinal, .Day, .Hour, .Minute, .Second], fromDate: self)
    }
}