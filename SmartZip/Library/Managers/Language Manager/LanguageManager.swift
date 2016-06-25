//
//  LanguageManager.swift
//
//  Created by Pawan Joshi on 05/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit

//let NSLocalizedString = LanguageManager.sharedInstance().localizedString // Override localized string

class LanguageManager: NSObject {
    
    // MARK: - Constants
    struct Constants {
        static let languageCodeKey = "LanguageCode" // The key against which to store the selected language code.
        static let defaultLanguageCode = "en" // Default language to english
    }
    
    
    var availableLocales: NSArray!
    
    // MARK: - Singleton Instance
    private static let _sharedManager = LanguageManager()
    
    class func sharedManager() -> LanguageManager {
        return _sharedManager
    }
    
    private override init() {
        super.init()
        
        // customize initialization
        
        // By defaut initlialize array with single default language.
        self.availableLocales = [LanguageManager.Constants.defaultLanguageCode]
    }
    
    /**
     Set and get the language code string in the user defaults.
     */
    var languageCode: NSString {
        
        get {
            let languageCode: String = NSUserDefaults.standardUserDefaults().stringForKey(LanguageManager.Constants.languageCodeKey)!
            return languageCode
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(languageCode, forKey: LanguageManager.Constants.languageCodeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    /**
     Override NSlocalizationString function to apply app localization.
     
     - parameter key:     A String of key
     - parameter comment: A String of cooment
     
     - returns: A String which contain updated value of string
     */
    func localizedString(key: String, comment: String) -> String {
        return self.translationForKey(key)
    }
    
    /**
     Translations for keys are found in the Localisable.strings files in the relevant .lproj folder for the selected language.
     
     - parameter key: A string is key whose translation we want
     
     - returns: A translate string which is resultant of given key
     */
    func translationForKey(key: String) -> String {
        
        // Get the relevant language bundle.
        let bundlePath: String = NSBundle.mainBundle().pathForResource(self.languageCode as String, ofType: "lproj")!
        let languageBundle: NSBundle = NSBundle(path: bundlePath)!
        
        // Get the translated string using the language bundle.
        if let translatedString: String = languageBundle.localizedStringForKey(key, value: key, table: nil) {
            return translatedString
        } else {
            return key
        }
    }
    
    /*
    Check the user defaults to find whether a localisation has been set before. If it hasn't been set, (i.e. first run of the app), select the locale based on the device locale setting.
    */
    func initializeLanguageIfNeeded() {
        
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // Check whether the language code has already been set.
        guard let _ = userDefaults.stringForKey(LanguageManager.Constants.languageCodeKey) else  {
            
            //Get current locale language form device
            let currentLocale: NSLocale = NSLocale.currentLocale()
            
            // Get language code form device
            let localeLanguageCode: String = currentLocale.objectForKey(NSLocaleLanguageCode) as! String
            
            // Iterate through available localisations to find the matching one for the device locale.
            for language in self.availableLocales  {
                
                if (language.caseInsensitiveCompare(localeLanguageCode) == NSComparisonResult.OrderedSame)   {
                    
                    // Set language in user default
                    self.languageCode = language as! NSString
                    break;
                }
            }
            
            // If the device locale doesn't match any of the available ones, just pick the first one.
            guard let _ = userDefaults.stringForKey(LanguageManager.Constants.languageCodeKey) else  {
                
                print("Couldn't find the right localisation - using default.")
                self.languageCode = LanguageManager.Constants.defaultLanguageCode // by default english language.
                return
            }
            
            return
        }
    }
}
