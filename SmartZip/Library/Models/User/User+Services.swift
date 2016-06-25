//
//  User+Services.swift
//
//  Created by Sourabh Bhardwaj on 07/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation

// MARK: - ### API Handling ###
extension User {

    // MARK: Edit Profile
    func editProfile(params: NSDictionary, completion: (success: Bool, error: NSError?) -> (Void)) {
        
        //FIXME: Incomplete Implementation
    }
    
    // MARK: Change Password
    func changePassword(params: [String : AnyObject], completion: (success: Bool, error: NSError?) -> (Void)) {
        
        RequestManager.sharedManager().performPost(Constants.APIServiceMethods.changePassword, params: params) { (response) -> Void in
            LogManager.logInfo("response = \(response)")
            
            if response.success {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: response.responseError)
            }
        }
    }
}
