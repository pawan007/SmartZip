//
//  Helper.swift
//
//  Created by Pawan Kumar on 15/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//


import Foundation

let DEVICE_ID_KEY = "deviceID"
let DEVICE_TYPE = "iOS"
let ACCESS_TOKEN_KEY = "accessToken"

/**
 Global function to check if the input object is initialized or not.
 
 - parameter value: value to verify for initialization
 
 - returns: true if initialized
 */
public func isObjectInitialized (value: AnyObject?) -> Bool {
    guard let _ = value else {
        return false
    }
    return true
}

public func documentsDirectoryPath () -> String? {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
}

public let documentsDirectoryURL: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

public let cacheDirectoryURL: NSURL = {
    let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
    return urls[urls.endIndex - 1]
}()

public func deviceId () -> String {
    
    if let deviceID = NSUserDefaults.objectForKey(DEVICE_ID_KEY) {
        return deviceID as! String
    } else {
        let deviceID = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        NSUserDefaults.setObject(deviceID, forKey: DEVICE_ID_KEY)
        return deviceID
    }
}

public func accessToken () -> String? {
    return NSUserDefaults.objectForKey(ACCESS_TOKEN_KEY) as? String
}

public func saveAccessToken (token: String) {
    NSUserDefaults.setObject(token, forKey: ACCESS_TOKEN_KEY)
}

public func deviceInfo () -> [String: String] {
    
    var deviceInfo = [String: String]()
    deviceInfo["deviceId"] = deviceId()
    deviceInfo["deviceType"] = DEVICE_TYPE
    deviceInfo["deviceToken"] = AppDelegate.delegate().deviceToken()
    
    return deviceInfo
}

public func addAdditionalParameters (params: [String: AnyObject]) -> [String: AnyObject] {
    
    var finalParams = params
    finalParams["deviceInfo"] = deviceInfo()
    return finalParams
}

/**
 Get version of application.
 
 - returns: Version of app
 */
public func applicationVersion () -> String {
    let info: NSDictionary = NSBundle.mainBundle().infoDictionary!
    return  info.objectForKey("CFBundleVersion") as! String
}

/**
 Get bundle identifier of application.
 
 - returns: NSBundle identifier of app
 */
func applicationBundleIdentifier () -> NSString {
    return NSBundle.mainBundle().bundleIdentifier!
}

/**
 Get name of application.
 
 - returns: Name of app
 */
func applicationName () -> String {
    let info:NSDictionary = NSBundle.mainBundle().infoDictionary!
    return  info.objectForKey("CFBundleDisplayName") as! String
}
