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
        static let MIX_PANNEL_TOKEN: String = "86c7fdce297bc1d025ea3d749a1e67da"
        static let FLURRY_APP_ID: String = "TS58ZK76CMHNJ7JKV5K3"
        static let GOOGLE_ANALYTICS_APP_ID: String = "UA-76023878-1"
    }
    
    struct Fonts {
        static let ProximaNovaSemiBold : String = "ProximaNovaA-Semibold"
        static let ProximaNovaRegular  : String = "ProximaNovaA-Regular"
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

let kAlertTitle = "SmartZip"
let kFileManager = NSFileManager.defaultManager()

// narender.mobirizer@gmail.com
// narender@mobirizer
let kGoogleAdUnitId       = "ca-app-pub-7753603434154239/"
let kGoogleBannerAdId     = "ca-app-pub-7753603434154239/4797926502"
let kGoogleInterstitialAd = "ca-app-pub-7753603434154239/6274659704"

let APPDELEGATE = UIApplication.sharedApplication().delegate as! AppDelegate










 