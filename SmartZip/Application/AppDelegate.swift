//
//  AppDelegate.swift
//  SmartZip
//
//  Created by Pawan Kumar on 25/06/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import UIKit
import MMDrawerController
import Firebase

//import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var isOpenedFromExternalResource = false
    var unzipFilePath = ""
    weak var flvc:FileListViewController?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        iRateSetUp()
        
        
        let appKey = "1pbpk77qpisojml"      // Set your own app key value here.
        let appSecret = "16ok6bvw4j50q8c"   // Set your own app secret value here.
        let dropboxSession = DBSession(appKey: appKey, appSecret: appSecret, root: kDBRootDropbox)
        DBSession.setSharedSession(dropboxSession)
        if let URL = launchOptions?[UIApplicationLaunchOptionsURLKey] as? NSURL {
            /*if URL.isFileReferenceURL() {
             
             }
             let vc = UIStoryboard.unZipVC()
             vc!.zipFilePath = URL.path!
             let navController:UINavigationController? = UINavigationController(rootViewController: vc!)
             navController?.navigationBarHidden = true
             self.window?.rootViewController = navController
             self.window?.makeKeyAndVisible()
             
             FIRApp.configure()
             
             return true*/
            print(URL)
            
            let unzipClass = UnZipExternal()
            unzipFilePath = unzipClass.unzipPath(URL.path!)
            isOpenedFromExternalResource = true
            
        }
        AppDelegate.presentRootViewController()
        
        if AppDelegate.delegate().getRigisterDevice() == ""  {
            AppDelegate.delegate().setRigisterDevice()
            let flurryParams = [ "deviceToken" :AppDelegate.delegate().deviceToken()]
            AnalyticsManager.sharedManager().trackEvent("New device register", attributes: flurryParams, screenName: "AppDelegate")
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(date)
        
        let flurryParams = [ "date" :dateString]
        AnalyticsManager.sharedManager().trackEvent("applicationDidEnterBackground", attributes: flurryParams, screenName: "AppDelegate")
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateString = dateFormatter.stringFromDate(date)
        
        let flurryParams = [ "date" :dateString]
        AnalyticsManager.sharedManager().trackEvent("applicationWillEnterForeground", attributes: flurryParams, screenName: "AppDelegate")
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let docDir = CommonFunctions.sharedInstance.docDirPath()
        if (sourceApplication! == "com.apple.mobilemail") || (url.path?.containsString(docDir))! {
            
            print(url)
            let unzipClass = UnZipExternal()
            //            unzipFilePath = unzipClass.unzipPath(url.path!)
            unzipClass.unzipPath(url.path!)
            isOpenedFromExternalResource = true 
            //            let fileName = newFilePath.componentsSeparatedByString("/").last
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "A zip fie has been imported and unzipped in My Files", vc: (self.window?.rootViewController)!)
            
            if APPDELEGATE.isOpenedFromExternalResource && FileParser.sharedInstance.currentPath == FileParser.sharedInstance.documentsURL() {
                APPDELEGATE.isOpenedFromExternalResource = false
                
                if flvc != nil {
                    flvc!.files = flvc!.parser.filesForDirectory(flvc!.initialPath!)
                    flvc!.indexFiles()
                    flvc!.tableView.reloadData()
                }
                
            }
            
            
            return true
        }
        
        if DBSession.sharedSession().handleOpenURL(url) {
            if DBSession.sharedSession().isLinked() {
                NSNotificationCenter.defaultCenter().postNotificationName("didLinkToDropboxAccountNotification", object: nil)
                return true
            }
        }
        
        return false
    }
    
    func iRateSetUp () {
        iRate.sharedInstance().applicationBundleID = "com.mobirizer.smartzip"
        iRate.sharedInstance().appStoreID = 1141913794
        iRate.sharedInstance().ratingsURL = NSURL(string: "https://itunes.apple.com/us/app/smartzip/id1141913794?ls=1&mt=8")
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
        
        let flagFirstTime = NSUserDefaults.standardUserDefaults().boolForKey("OpenFirstTime")
        
        var viewController:UINavigationController?
        
        if flagFirstTime == false {
            // Show Tutorial
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "OpenFirstTime")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            viewController = storyboard.instantiateViewControllerWithIdentifier("TutorialContainer") as? UINavigationController
            
        }else{
            // show Home
            
            viewController = storyboard.instantiateViewControllerWithIdentifier("HomeMenuContainerNew") as? UINavigationController
            
        }
        
        
        
        let menuManager = SideMenuManager.sharedManager()
        menuManager.setValues { (drawer: MMDrawerController) -> () in
            drawer.leftDrawerViewController = leftDrawer
            drawer.centerViewController = viewController
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


extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}





