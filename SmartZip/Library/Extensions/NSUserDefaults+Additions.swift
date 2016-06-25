//
//  NSUserDefaults+Additions.swift
//
//  Created by Anish Kumar on 20/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

// MARK: - NSUserDefaults Extension
extension NSUserDefaults {
    
    // MARK: - User Defaults
    /**
     sets/adds object to NSUserDefaults
     
     - parameter aObject: object to be stored
     - parameter defaultName: key for object
     */
    class func setObject(value: AnyObject?, forKey defaultName: String) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: defaultName)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
     gives stored object in NSUserDefaults for a key
     
     - parameter defaultName: key for object
     
     - returns: stored object for key
     */
    class func objectForKey(defaultName: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(defaultName)
    }
    
    /**
     removes object from NSUserDefault stored for a given key
     
     - parameter defaultName: key for object
     */
    class func removeObjectForKey(defaultName: String) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(defaultName)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}