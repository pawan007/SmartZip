//
//  Int+NSTimeInterval.swift
//
//  Created by Anish Kumar on 30/03/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
/**
 NSTimeInterval conversion extensions
 */

public extension Int {
    
    var seconds: NSTimeInterval {
        return NSTimeInterval(self)
    }
    var minutes: NSTimeInterval {
        return 60 * self.seconds
    }
    var hours: NSTimeInterval {
        return 60 * self.minutes
    }
    var days: NSTimeInterval {
        return 24 * self.hours
    }
    var years: NSTimeInterval {
        return 365 * self.days
    }
}