//
//  AppDelegate+Notification.swift
//
//  Created by Pawan Kumar on 17/05/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    struct Keys {
        static let deviceToken = "deviceToken"
        static let deviceIsRegister = "deviceIsRegister"

    }
    
    // MARK: - UIApplicationDelegate Methods
    func application (application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        LogManager.logDebug("Device Push Token \(String(data: deviceToken, encoding: NSUTF8StringEncoding))")
        // Prepare the Device Token for Registration (remove spaces and < >)
        
        self.setDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        LogManager.logError(error.localizedDescription)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        self.recievedRemoteNotification(userInfo)
    }
    
    
    // MARK: - Private Methods
    /**
     Register remote notification to send notifications
     */
    func registerRemoteNotification () {
        
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    /**
     Deregister remote notification
     */
    func deregisterRemoteNotification () {
        UIApplication.sharedApplication().unregisterForRemoteNotifications()
    }
    
    func setDeviceToken (token: NSData) {
        let deviceToken = token.description.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "") ?? ""
        NSUserDefaults.setObject(deviceToken, forKey: Keys.deviceToken)
    }
    
    func deviceToken () -> String {
        let deviceToken: String? = NSUserDefaults.objectForKey(Keys.deviceToken) as? String
        
        if isObjectInitialized(deviceToken) {
            return deviceToken!
        }
        
        return ""
    }
    
    
    func setRigisterDevice () {
             NSUserDefaults.setObject("register", forKey: Keys.deviceToken)
    }
    
    func getRigisterDevice () -> String {
        let deviceIsRegister: String? = NSUserDefaults.objectForKey(Keys.deviceIsRegister) as? String
        if isObjectInitialized(deviceIsRegister) {
            return deviceIsRegister!
        }
        return ""
    }
    
    /**
     Receive information from remote notification. Parse response.
     
     - parameter userInfo: Response from server
     */
    func recievedRemoteNotification (userInfo: NSDictionary) {
        
        let dictioaryUserInfo: NSDictionary = userInfo["aps"] as! NSDictionary
        
        if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
            if let _ = dictioaryUserInfo["alert"] {
                
                let dictionaryData: NSDictionary = dictioaryUserInfo["data"] as! NSDictionary
                if dictionaryData.isEqual(NSNull) {
                    return
                }
                
                if let userInfo = dictionaryData["user_info"] {
                    
                    // get data as per requirement
                    LogManager.logDebug(userInfo.description)
                }
            }
        }
    }
}