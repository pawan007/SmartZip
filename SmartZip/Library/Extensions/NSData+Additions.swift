//
//  NSData+Additions.swift
//
//  Created by Pawan Joshi on 04/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

// MARK: - NSData Extension
extension Data {
    
    func json() -> AnyObject? {
        
        var object: AnyObject?
        
        do {
            object = try JSONSerialization.jsonObject(with: self, options: []) as! [String:AnyObject] as AnyObject
            // use anyObj here
        } catch {
            print("json error: \(error)")
        }
        
        return object
    }
}
