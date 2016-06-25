//
//  AnalyticsManager.swift
//
//  Created by Geetika Gupta on 06/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Mixpanel
import Flurry_iOS_SDK

enum PlatformType {
    case MixPannel
    case Flurry
    case GoogleAnalytics
}

class AnalyticsManager: NSObject {
    
    var platformType: PlatformType = .Flurry
    
    // MARK: - Singleton Instance
    private static let _sharedManager = AnalyticsManager()
    
    class func sharedManager() -> AnalyticsManager {
        return _sharedManager
    }    
    
    private override init() {
        super.init()
        
        // customize initialization
    }
    
    /**
     Method to initialize track tool as per their selection.
     
     - parameter tool: A type of track tool
    */
    func initializeTracker() {
        
        switch self.platformType {
            
        case .Flurry:
            Flurry.startSession(Constants.Tokens.FLURRY_APP_ID);
            Flurry.setCrashReportingEnabled(true)
            
        case .GoogleAnalytics:
            self.googleAnalyserInitialize()
            
        default: // .MixPannel:
            Mixpanel.sharedInstanceWithToken(Constants.Tokens.MIX_PANNEL_TOKEN)
        }
    }
    
    /**
     Track event on particular event.
     
     - parameter eventName:  A String is a event name which we want to given for track
     - parameter attributes: A Dictionary to ass more attribute
     - parameter tool:       track tool which contain type of tool which we want to prefer for tracking
     - parameter screenName: A String is a screen name
     */
    func trackEvent(eventName: String, attributes: NSDictionary?, screenName: String?) {
        
        switch self.platformType {
            
        case .Flurry:
            Flurry.logEvent(eventName, withParameters: attributes as! [NSObject : AnyObject])
            
        case .GoogleAnalytics: break
//            let tracker = GAI.sharedInstance().defaultTracker
//            tracker.set(kGAIEvent, value: eventName)
//
//            let builder = GAIDictionaryBuilder.createEventWithCategory(eventName, action: nil, label:screenName, value: 0)
//            tracker.send(builder.build() as [NSObject : AnyObject])
            
        default: // .MixPannel:
            Mixpanel.sharedInstance().track(eventName, properties: (attributes as! [NSObject : AnyObject])) //Plan selected)
        }
    }
    
    /**
     A initializer method to initiate google analyser for start tracking.
     */
    func googleAnalyserInitialize () {
        
        //var configureError:NSError?
        //GGLContext.sharedInstance().configureWithError(&configureError)
        //assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
//        let gai = GAI.sharedInstance()
//        let tracker:GAITracker = gai.trackerWithTrackingId(GOOGLE_ANALYTICS_APP_ID)
        
        // Enable Remarketing, Demographics & Interests reports.
//        tracker.allowIDFACollection = true
        
        // Optional: configure GAI options.
//        gai.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai.LogManager.logLevel = GAILogLevel.Verbose  // remove before app release
    }
}
