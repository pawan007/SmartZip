//
//  AppDelegate.swift
//  SmartZip
//
//  Created by Pawan Kumar on 25/06/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import UIKit
import MMDrawerController

//import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        iRateSetUp()
        
        
        let appKey = "xhhur59zpqig0ob"      // Set your own app key value here.
        let appSecret = "js2v6cbtl5oysjd"   // Set your own app secret value here.
        let dropboxSession = DBSession(appKey: appKey, appSecret: appSecret, root: kDBRootDropbox)
        DBSession.setSharedSession(dropboxSession)
        if let URL = launchOptions?[UIApplicationLaunchOptionsURLKey] as? NSURL {
            if URL.isFileReferenceURL() {
                
            }
            let vc = UIStoryboard.unZipVC()
            vc!.zipFilePath = URL.path!
            let navController:UINavigationController? = UINavigationController(rootViewController: vc!)
            navController?.navigationBarHidden = true
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
            return true
        }
        AppDelegate.presentRootViewController()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if DBSession.sharedSession().handleOpenURL(url) {
            if DBSession.sharedSession().isLinked() {
                NSNotificationCenter.defaultCenter().postNotificationName("didLinkToDropboxAccountNotification", object: nil)
                return true
            }
        }
        
        return false
    }
    
    func iRateSetUp () {
        iRate.sharedInstance().applicationBundleID = "com.modi.SmartZip"
        iRate.sharedInstance().appStoreID = 553834731
        iRate.sharedInstance().ratingsURL = NSURL(string: "https://itunes.apple.com/in/app/candy-crush-saga/id553834731?mt=8")
        iRate.sharedInstance().onlyPromptIfLatestVersion = false
        iRate.sharedInstance().previewMode = false
        iRate.sharedInstance().daysUntilPrompt = 1
        iRate.sharedInstance().usesUntilPrompt = 2
    }
    
    
}


extension UIStoryboard {
    
    class func storyboardMain() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    
    class func photoPickerVC() -> PhotoPickerVC? {
        return storyboardMain().instantiateViewControllerWithIdentifier("PhotoPickerVC") as? PhotoPickerVC
    }
    
    class func dropBoxVC() -> DropBoxVC? {
        return storyboardMain().instantiateViewControllerWithIdentifier("DropBoxVC") as? DropBoxVC
    }
    class func googleDriveVC() -> GoogleDriveVC? {
        return storyboardMain().instantiateViewControllerWithIdentifier("GoogleDriveVC") as? GoogleDriveVC
    }
    
    class func unZipVC() -> UnZipVC? {
        return storyboardMain().instantiateViewControllerWithIdentifier("UnZipVC") as? UnZipVC
    }
    
    class func contentViewer() -> ContentViewer? {
        return storyboardMain().instantiateViewControllerWithIdentifier("ContentViewer") as? ContentViewer
    }
    
    
    
}

extension AppDelegate {
    
    // MARK: - App Delegate Ref
    class func delegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func switchAppToStoryboard(name: String, storyboardId: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewControllerWithIdentifier(storyboardId)
    }
    
    // MARK: - Root View Controller
    class func presentRootViewController(animated: Bool = false) {
        
        if (animated) {
            let animation:CATransition = CATransition()
            animation.duration = CFTimeInterval(0.5)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionMoveIn
            animation.subtype = kCATransitionFromTop
            animation.fillMode = kCAFillModeForwards
            AppDelegate.delegate().window?.layer.addAnimation(animation, forKey: "animation")
            AppDelegate.delegate().window?.rootViewController = AppDelegate.rootViewController()
        }
        else {
            AppDelegate.delegate().window?.rootViewController = AppDelegate.rootViewController()
        }
    }
    
    class func rootViewController() -> UIViewController! {
        
        return AppDelegate.rootControllerForLoggenInUser()
    }
    
    class func rootControllerForLoggenInUser() -> UIViewController
    {
        let storyboard = UIStoryboard.mainStoryboard()
        
        let leftDrawer = storyboard.instantiateViewControllerWithIdentifier("LeftMenuViewController")
        let center = storyboard.instantiateViewControllerWithIdentifier("HomeMenuContainer")
        
        let menuManager = SideMenuManager.sharedManager()
        menuManager.setValues { (drawer: MMDrawerController) -> () in
            drawer.leftDrawerViewController = leftDrawer
            drawer.centerViewController = center
        }
        return SideMenuManager.sharedManager().container!
    }
    
    //    private func enableInputAccessoryView() {
    //        IQKeyboardManager.sharedManager().enable = true
    //        IQKeyboardManager.sharedManager().toolbarTintColor = UIColor.orangeColor()
    //        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
    //        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    //    }
    
    private func setupLogger() {
        #if DEBUG
            LogManager.setup(.Debug)
        #else
            LogManager.setup(.Error)
        #endif
    }
    
    
}



