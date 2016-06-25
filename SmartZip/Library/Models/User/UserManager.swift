//
//  UserManager.swift
//
//  Created by Sourabh Bhardwaj on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

let ACTIVE_USER_KEY = "activeUser"
let LOGGED_USER_EMAIL_KEY = "userEmail"
let TUTORIAL_VIEWED_KEY = "userViewedTutorial"


/// User Manager - manages all feature for User model
class UserManager: NSObject {

    private var _activeUser: User?
    
    var activeUser: User! {
        get {
            return _activeUser
        }
        set {
            _activeUser = newValue
            self.saveActiveUser()
        }
    }
    
    // MARK: Singleton Instance
    private static let _sharedManager = UserManager()
    
    class func sharedManager() -> UserManager {
        return _sharedManager
    }
    
    private override init() {
        // initiate any queues / arrays / filepaths etc
        super.init()
        
        // Load last logged user data if exists
        if isUserLoggedIn() {
            loadActiveUser()
        }
    }
    
    func isUserLoggedIn() -> Bool {

        guard let _ = NSUserDefaults.objectForKey(ACTIVE_USER_KEY)
            else {
                return false
        }
        return true
    }
    
    func hasUserViewedTutorial() -> Bool {
        
        guard let _ = NSUserDefaults.objectForKey(TUTORIAL_VIEWED_KEY)
            else {
                return false
        }
        return true
    }
    
    func userLogout() {
        
    }
    
    // MARK: - KeyChain / User Defaults / Flat file / XML

    /**
    Load last logged user data, if any
    */
    func loadActiveUser() {
        
        guard let decodedUser = NSUserDefaults.objectForKey(ACTIVE_USER_KEY) as? NSData,
        let user = NSKeyedUnarchiver.unarchiveObjectWithData(decodedUser) as? User
        else {
            return
        }
        self.activeUser = user
    }
    
    func lastLoggedUserEmail() -> String? {
        return NSUserDefaults.objectForKey(LOGGED_USER_EMAIL_KEY) as? String
    }
    
    /**
     Save current user data
     */
    func saveActiveUser()
    {
        NSUserDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(self.activeUser), forKey: ACTIVE_USER_KEY)
        
        if let email = self.activeUser.email {
            NSUserDefaults.setObject(email, forKey: LOGGED_USER_EMAIL_KEY)
        }
    }
    
    /**
     Update current user data
     */
    func updateActiveUser() {
        saveActiveUser()
    }
    
    /**
     Delete current user data
     */
    func deleteActiveUser()
    {
        // remove active user from storage
        NSUserDefaults.removeObjectForKey(ACTIVE_USER_KEY)
        NSUserDefaults.removeObjectForKey(LOGGED_USER_EMAIL_KEY)
        _activeUser = nil
    }
}

// MARK: API Services

extension UserManager {
    
    // MARK: Login
    func performLogin(params: [String: AnyObject], completion: (success: Bool, error: NSError?) -> (Void)) {
        
        let finalParams = addAdditionalParameters(params)
        
        RequestManager.sharedManager().performPost(Constants.APIServiceMethods.loginAPI, params: finalParams) { (response) -> Void in
            
            if response.success {
                // parse the response
                if let accessToken =  response.resultDictionary?.valueForKeyPath("result.accessToken") {
                    saveAccessToken(accessToken as! String)
                    
                    if let userDict = response.resultDictionary?.valueForKeyPath("result.user") {
                        let user: User = ModelMapper<User>.map(userDict as! [String : AnyObject])!
                        self.activeUser = user
                        
                        completion(success: true, error: nil)
                    } else {
                        completion(success: false, error: response.responseError)
                    }
                } else {
                    completion(success: false, error: response.responseError)
                }
                
            } else {
                completion(success: false, error: response.responseError)
            }
        }
    }
    
    func uploadUserPhoto(profileImage: UIImage, completion: (success: Bool, error: NSError?) -> (Void)) {
        
        var fileParams = [String: AnyObject]()
        fileParams["key"] = "profileImage"
        fileParams["fileName"] = "userImage.jpg"
        fileParams["value"] = UIImageJPEGRepresentation(profileImage, 0.2)
        fileParams["contentType"] = "image/jpeg"
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Constants.APIServiceMethods.imageUploadAPI)!)
        request.setMultipartFormData(nil, fileFields: [fileParams])

        RequestManager.sharedManager().performRequest(request, userInfo: nil) { (response) -> Void in
            
            if response.success {
                // parse the response
                
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: response.responseError)
            }
        }
    }
    
    // MARK: Reset Password
    func resetPassword(params: [String: AnyObject], completion: (success: Bool, error: NSError?) -> (Void)) {
        
        let finalParams = addAdditionalParameters(params)
        
        RequestManager.sharedManager().performPost(Constants.APIServiceMethods.resetPassword, params: finalParams) { (response) -> Void in
            LogManager.logInfo("response = \(response)")
            
            if response.success {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: response.responseError)
            }
        }
    }
    
    // MARK: Sign Up
    func performSignUp(params: [String: AnyObject], completion: (success: Bool, error: NSError?) -> (Void)) {
        
        let finalParams = addAdditionalParameters(params)
        
        RequestManager.sharedManager().performPost(Constants.APIServiceMethods.sigupAPI, params: finalParams) { (response) -> Void in
            
            if response.success {
                // parse the response
                
                if let accessToken =  response.resultDictionary?.valueForKeyPath("result.accessToken") {
                    saveAccessToken(accessToken as! String)
                    
                    if let userDict = response.resultDictionary?.valueForKeyPath("result.user") {
                        let user: User = ModelMapper<User>.map(userDict as! [String : AnyObject])!
                        self.activeUser = user
                        
                        completion(success: true, error: nil)
                    } else {
                        completion(success: false, error: response.responseError)
                    }
                } else {
                    completion(success: false, error: response.responseError)
                }
            } else {
                completion(success: false, error: response.responseError)
            }
        }
    }
    
    // MARK: Logout
    func performLogout(completion: (success: Bool, error: NSError?) -> (Void)) {
        
        RequestManager.sharedManager().performGet(Constants.APIServiceMethods.logoutAPI, params: nil) { (response) -> Void in
            
            if response.success {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: response.responseError)
            }
        }
    }
    
    func guestUserLogin(params: [String: AnyObject], completion: (success: Bool, error: NSError?) -> (Void)) {
        
        RequestManager.sharedManager().performPost(Constants.APIServiceMethods.guestUserLogin, params: params) { (response) -> Void in
            
            if response.success {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: response.responseError)
            }
        }
    }

}