//
//  NSDate+Operators.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

// MARK: Arithmetic

func +(date: NSDate, timeInterval: Int) -> NSDate {
    return date + NSTimeInterval(timeInterval)
}

func -(date: NSDate, timeInterval: Int) -> NSDate {
    return date - NSTimeInterval(timeInterval)
}

func +=(inout date: NSDate, timeInterval: Int) {
    date = date + timeInterval
}

func -=(inout date: NSDate, timeInterval: Int) {
    date = date - timeInterval
}

func +(date: NSDate, timeInterval: Double) -> NSDate {
    return date.dateByAddingTimeInterval(NSTimeInterval(timeInterval))
}

func -(date: NSDate, timeInterval: Double) -> NSDate {
    return date.dateByAddingTimeInterval(NSTimeInterval(-timeInterval))
}

func +=(inout date: NSDate, timeInterval: Double) {
    date = date + timeInterval
}

func -=(inout date: NSDate, timeInterval: Double) {
    date = date - timeInterval
}

func -(date: NSDate, otherDate: NSDate) -> NSTimeInterval {
    return date.timeIntervalSinceDate(otherDate)
}


public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedSame
}


public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedAscending
}

