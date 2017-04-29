//
//  Reachability.swift
//  SmartZip
//
//  Created by Pawan Dhawan on 09/08/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import SystemConfiguration

public enum ReachabilityType {
    case wwan,
    wiFi,
    notConnected
}

open class Reachability {
    
    /**
     :see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
     */
    class func isConnectedToNetwork() -> Bool {
        return true
    }
    
    
    
}
