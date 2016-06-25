//
//  NSDate+Formatters.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

public extension NSDate {
    
    public class func dateFormatCCCCDDMMMYYYY() ->String {
        return "cccc, dd MMM yyyy"
    }
    public class func dateFormatCCCCDDMMMMYYYY() ->String {
        return "cccc, dd MMMM yyyy"
    }
    public class func dateFormatDDMMMYYYY() ->String {
        return "dd MMM yyyy"
    }
    public class func dateFormatDDMMYYYYDashed() ->String {
        return "dd-MM-yyyy"
    }
    public class func dateFormatDDMMYYYYSlashed() ->String {
        return "dd/MM/yyyy"
    }
    public class func dateFormatDDMMMYYYYSlashed() ->String {
        return "dd/MMM/yyyy"
    }
    public class func dateFormatMMMDDYYYY() ->String {
        return "MMM dd, yyyy"
    }
    public class func dateFormatYYYYMMDDDashed() ->String {
        return "yyyy-MM-dd"
    }
    
    public func formattedString() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = NSDate.dateFormatDDMMYYYYDashed()
        return formatter.stringFromDate(self)
    }
    
    public func formattedStringUsingFormat(format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
}