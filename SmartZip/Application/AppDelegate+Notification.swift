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
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        LogManager.logDebug("Device Push Token \(String(data: deviceToken, encoding: String.Encoding.utf8))")
        // Prepare the Device Token for Registration (remove spaces and < >)
        
        self.setDeviceToken(deviceToken)
    }
    
    @nonobjc func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        LogManager.logError(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        self.recievedRemoteNotification(userInfo as NSDictionary)
    }
    
    
    // MARK: - Private Methods
    /**
     Register remote notification to send notifications
     */
    func registerRemoteNotification () {
        
        let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    /**
     Deregister remote notification
     */
    func deregisterRemoteNotification () {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    func setDeviceToken (_ token: Data) {
        let deviceToken = token.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "") ?? ""
        UserDefaults.setObject(deviceToken, forKey: Keys.deviceToken)
    }
    
    func deviceToken () -> String {
        let deviceToken: String? = UserDefaults.objectForKey(Keys.deviceToken) as? String
        
        if isObjectInitialized(deviceToken as AnyObject?) {
            return deviceToken!
        }
        
        return ""
    }
    
    
    func setRigisterDevice () {
             UserDefaults.setObject("register" as AnyObject?, forKey: Keys.deviceToken)
    }
    
    func getRigisterDevice () -> String {
        let deviceIsRegister: String? = UserDefaults.objectForKey(Keys.deviceIsRegister) as? String
        if isObjectInitialized(deviceIsRegister as AnyObject?) {
            return deviceIsRegister!
        }
        return ""
    }
    
    /**
     Receive information from remote notification. Parse response.
     
     - parameter userInfo: Response from server
     */
    func recievedRemoteNotification (_ userInfo: NSDictionary) {
        
        let dictioaryUserInfo: NSDictionary = userInfo["aps"] as! NSDictionary
        
        if UIApplication.shared.applicationState == UIApplicationState.active {
            if let _ = dictioaryUserInfo["alert"] {
                
                let dictionaryData: NSDictionary = dictioaryUserInfo["data"] as! NSDictionary
                if dictionaryData.isEqual(NSNull) {
                    return
                }
                
                if let userInfo = dictionaryData["user_info"] {
                    
                    // get data as per requirement
                    LogManager.logDebug((userInfo as AnyObject).description)
                }
            }
        }
    }
}
