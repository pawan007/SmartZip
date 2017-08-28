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
public func isObjectInitialized (_ value: AnyObject?) -> Bool {
    guard let _ = value else {
        return false
    }
    return true
}

public func documentsDirectoryPath () -> String? {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
}

public let documentsDirectoryURL: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1]
}()

public let cacheDirectoryURL: URL = {
    let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[urls.endIndex - 1]
}()

public func deviceId () -> String {
    
    if let deviceID = UserDefaults.objectForKey(DEVICE_ID_KEY) {
        return deviceID as! String
    } else {
        let deviceID = UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        UserDefaults.setObject(deviceID, forKey: DEVICE_ID_KEY)
        return deviceID
    }
}

public func accessToken () -> String? {
    return UserDefaults.objectForKey(ACCESS_TOKEN_KEY) as? String
}

public func saveAccessToken (_ token: String) {
    UserDefaults.setObject(token, forKey: ACCESS_TOKEN_KEY)
}

public func deviceInfo () -> [String: String] {
    
    var deviceInfo = [String: String]()
    deviceInfo["deviceId"] = deviceId()
    deviceInfo["deviceType"] = DEVICE_TYPE
    deviceInfo["deviceToken"] = AppDelegate.delegate().deviceToken()
    
    return deviceInfo
}

public func addAdditionalParameters (_ params: [String: AnyObject]) -> [String: AnyObject] {
    
    var finalParams = params
    finalParams["deviceInfo"] = deviceInfo() as AnyObject
    return finalParams
}

/**
 Get version of application.
 
 - returns: Version of app
 */
public func applicationVersion () -> String {
    let info: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
    return  info.object(forKey: "CFBundleVersion") as! String
}

/**
 Get bundle identifier of application.
 
 - returns: NSBundle identifier of app
 */
func applicationBundleIdentifier () -> NSString {
    return Bundle.main.bundleIdentifier! as NSString
}

/**
 Get name of application.
 
 - returns: Name of app
 */
func applicationName () -> String {
    let info:NSDictionary = Bundle.main.infoDictionary! as NSDictionary
    return  info.object(forKey: "CFBundleDisplayName") as! String
}
