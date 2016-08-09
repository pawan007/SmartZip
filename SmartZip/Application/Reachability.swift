//
//  Reachability.swift
//  SmartZip
//
//  Created by Pawan Dhawan on 09/08/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import SystemConfiguration

public enum ReachabilityType {
    case WWAN,
    WiFi,
    NotConnected
}

public class Reachability {
    
    /**
     :see: Original post - http://www.chrisdanielson.com/2009/07/22/iphone-network-connectivity-test-example/
     */
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
}