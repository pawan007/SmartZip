//
//  Constants.swift
//
//  Created by Pawan Kumar on 01/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation

struct Constants {
    
    static let DEFAULT_SCREEN_RATIO: CGFloat = 375.0    
    static let PASSWORD_REGEX: String = "^[a-zA-Z0-9]{5,15}$"

    // MARK: Tokens
    struct Tokens {
        static let MIX_PANNEL_TOKEN: String = "1a9b461626c25e7918bebe789c21571b"
        static let FLURRY_APP_ID: String = "TS58ZK76CMHNJ7JKV5K3"
        static let GOOGLE_ANALYTICS_APP_ID: String = "UA-76023878-1"
    }
    
    struct Fonts {
        static let ProximaNovaSemiBold : String = "ProximaNovaA-Semibold"
        static let ProximaNovaRegular  : String = "ProximaNovaA-Regular"
    }
    
    
    static let BASE_URL = ConfigurationManager.sharedManager().APIEndPoint()
    
    struct Urls {
        static let termsAndConditons = Constants.BASE_URL + "/user/termsandconditons"
        static let privacyPolicy = BASE_URL + "/user/privacypolicy"
        static let aboutUs = BASE_URL + "/user/aboutus"
    }
    
    // MARK: APIServiceMethods
    struct APIServiceMethods {
        static let loginAPI = Constants.APIServiceMethods.apiURL("user/login")
        static let socialLoginAPI = Constants.APIServiceMethods.apiURL("user/socialLogin")
        static let otpLoginAPI = Constants.APIServiceMethods.apiURL("user/getotp")
        static let otpLoginVerify = Constants.APIServiceMethods.apiURL("user/otpverification")
        static let loginWithPhoneAPI = Constants.APIServiceMethods.apiURL("loginwithphone")
        static let logoutAPI = Constants.APIServiceMethods.apiURL("user/signout")
        static let sigupAPI = Constants.APIServiceMethods.apiURL("user/signup")
        static let imageUploadAPI = Constants.APIServiceMethods.apiURL("user/uploadfile")
        static let sendOtpAPI = Constants.APIServiceMethods.apiURL("getotp")
        static let verifyOtpAPI = Constants.APIServiceMethods.apiURL("otpverification")
        static let resetPassword = Constants.APIServiceMethods.apiURL("user/forgotpassword")
        static let changePassword = Constants.APIServiceMethods.apiURL("user/changepassword")
        static let getEvetsAPI = Constants.APIServiceMethods.apiURL("event/eventlist")
        static let getFiltersAPI = Constants.APIServiceMethods.apiURL("event/filters")
        static let guestUserLogin = Constants.APIServiceMethods.apiURL("user/guestuser")
        static let getFavouriteAPI = Constants.APIServiceMethods.apiURL("event/favouritelist")

        static let getEventdetailAPI = Constants.APIServiceMethods.apiURL("event/eventdetail")
        static let getAddfavouriteAPI = Constants.APIServiceMethods.apiURL("event/addfavourite")
        static let getRemovefavouriteAPI = Constants.APIServiceMethods.apiURL("event/removefavourite")

        
         static func apiURL(methodName: String) -> String {
            return Constants.BASE_URL + "/" + methodName
        }
    }
    
    struct UserMessages {
        static let enterValidCredentialsMessage =   "Please enter a valid email and password."
        static let missingEmail =                   "Please enter a valid email."
        static let missingPassword =                "Please enter a valid password."
        static let shortPasswordMessage =           "Password must be of minimum 6 characters."
        static let passwordChangeSuccess =          "Your password has been changed."
        static let passwordSentMessage =            "A new password has been sent to your email."
        static let mailAccountRequired =            "Please configure a mail account to send email."
        }
    
}
