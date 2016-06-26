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
    var Timestamp: String {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD-HH-mm-ss"
        return dateFormatter.stringFromDate(date)
    }
    
    let ResTypeAudio = "audio"
    let ResTypeVideo = "video"
    let ResTypeImage = "image"
    let ResTypeDoc = "document"
}
