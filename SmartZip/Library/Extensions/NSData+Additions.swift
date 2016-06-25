//
//  NSData+Additions.swift
//
//  Created by Pawan Joshi on 04/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

// MARK: - NSData Extension
extension NSData {
    
    func json() -> AnyObject? {
        
        var object: AnyObject?
        
        do {
            object = try NSJSONSerialization.JSONObjectWithData(self, options: []) as! [String:AnyObject]
            // use anyObj here
        } catch {
            print("json error: \(error)")
        }
        
        return object
    }
}