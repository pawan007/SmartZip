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
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        iRateSetUp()
        
        
        let appKey = "1pbpk77qpisojml"      // Set your own app key value here.
        let appSecret = "16ok6bvw4j50q8c"   // Set your own app secret value here.
        let dropboxSession = DBSession(appKey: appKey, appSecret: appSecret, root: kDBRootDropbox)
        DBSession.setShared(dropboxSession)
        if let URL = launchOptions?[UIApplicationLaunchOptionsKey.url] as? URL {
            
            print(URL)
            if URL.path.contains(".rar"){
            
                let rarClass = RarClasses()
                rarClass.uncompressFiles(fromOutside: URL.path)
                isOpenedFromExternalResource = true
                
            }else if URL.path.contains(".7z"){
                
                let extract7z = Extract7z()
                extract7z.uncompressFiles(fromOutside: URL.path)
                isOpenedFromExternalResource = true
                
            }else{
            
                let unzipClass = UnZipExternal()
                unzipFilePath = unzipClass.unzipPath(URL.path)
                isOpenedFromExternalResource = true
            }
            
            
        }
        AppDelegate.presentRootViewController()
        
        if AppDelegate.delegate().getRigisterDevice() == ""  {
            AppDelegate.delegate().setRigisterDevice()
            let flurryParams = [ "deviceToken" :AppDelegate.delegate().deviceToken()]
            AnalyticsManager.sharedManager().trackEvent("New device register", attributes: flurryParams as NSDictionary?, screenName: "AppDelegate")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let dateString = dateFormatter.string(from: date)
        
        let flurryParams = [ "date" :dateString]
        AnalyticsManager.sharedManager().trackEvent("applicationDidEnterBackground", attributes: flurryParams as NSDictionary?, screenName: "AppDelegate")
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let dateString = dateFormatter.string(from: date)
        
        let flurryParams = [ "date" :dateString]
        AnalyticsManager.sharedManager().trackEvent("applicationWillEnterForeground", attributes: flurryParams as NSDictionary?, screenName: "AppDelegate")
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let docDir = CommonFunctions.sharedInstance.docDirPath()
        if (sourceApplication! == "com.apple.mobilemail") || (url.path.contains(docDir)) {
            
            print(url)
            
            if url.path.contains(".zip") {
            
                let unzipClass = UnZipExternal()
                //            unzipFilePath = unzipClass.unzipPath(url.path!)
                _ = unzipClass.unzipPath(url.path)
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
                
            }else if url.path.contains(".rar"){
            
                let rarClass = RarClasses()
                rarClass.uncompressFiles(fromOutside: url.path)
                isOpenedFromExternalResource = true
                CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "A rar fie has been imported and unarchived in My Files", vc: (self.window?.rootViewController)!)
                
                if APPDELEGATE.isOpenedFromExternalResource && FileParser.sharedInstance.currentPath == FileParser.sharedInstance.documentsURL() {
                    APPDELEGATE.isOpenedFromExternalResource = false
                    
                    if flvc != nil {
                        flvc!.files = flvc!.parser.filesForDirectory(flvc!.initialPath!)
                        flvc!.indexFiles()
                        flvc!.tableView.reloadData()
                    }
                    
                }
            }else if url.path.contains(".7z"){
                
                let extract7z = Extract7z()
                extract7z.uncompressFiles(fromOutside: url.path)
                isOpenedFromExternalResource = true
                CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "A 7z fie has been imported and unarchived in My Files", vc: (self.window?.rootViewController)!)
                
                if APPDELEGATE.isOpenedFromExternalResource && FileParser.sharedInstance.currentPath == FileParser.sharedInstance.documentsURL() {
                    APPDELEGATE.isOpenedFromExternalResource = false
                    
                    if flvc != nil {
                        flvc!.files = flvc!.parser.filesForDirectory(flvc!.initialPath!)
                        flvc!.indexFiles()
                        flvc!.tableView.reloadData()
                    }
                    
                }
            }
            return true
        }
        
        if DBSession.shared().handleOpen(url) {
            if DBSession.shared().isLinked() {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "didLinkToDropboxAccountNotification"), object: nil)
                return true
            }
        }
        
        return false
    }
    
    func iRateSetUp () {
        iRate.sharedInstance().applicationBundleID = "com.mobirizer.smartzip"
        iRate.sharedInstance().appStoreID = 1141913794
        iRate.sharedInstance().ratingsURL = URL(string: "https://itunes.apple.com/us/app/smartzip/id1141913794?ls=1&mt=8")
        iRate.sharedInstance().onlyPromptIfLatestVersion = false
        iRate.sharedInstance().previewMode = false
        iRate.sharedInstance().daysUntilPrompt = 1
        iRate.sharedInstance().usesUntilPrompt = 2
    }
    
    
}


extension UIStoryboard {
    
    class func storyboardMain() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    
    class func photoPickerVC() -> PhotoPickerVC? {
        return storyboardMain().instantiateViewController(withIdentifier: "PhotoPickerVC") as? PhotoPickerVC
    }
    
    class func dropBoxVC() -> DropBoxVC? {
        return storyboardMain().instantiateViewController(withIdentifier: "DropBoxVC") as? DropBoxVC
    }
    class func googleDriveVC() -> GoogleDriveVC? {
        return storyboardMain().instantiateViewController(withIdentifier: "GoogleDriveVC") as? GoogleDriveVC
    }
    
    class func unZipVC() -> UnZipVC? {
        return storyboardMain().instantiateViewController(withIdentifier: "UnZipVC") as? UnZipVC
    }
    
    class func contentViewer() -> ContentViewer? {
        return storyboardMain().instantiateViewController(withIdentifier: "ContentViewer") as? ContentViewer
    }
    
    
    
}

extension AppDelegate {
    
    // MARK: - App Delegate Ref
    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func switchAppToStoryboard(_ name: String, storyboardId: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
    
    // MARK: - Root View Controller
    class func presentRootViewController(_ animated: Bool = false) {
        
        if (animated) {
            let animation:CATransition = CATransition()
            animation.duration = CFTimeInterval(0.5)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.type = kCATransitionMoveIn
            animation.subtype = kCATransitionFromTop
            animation.fillMode = kCAFillModeForwards
            AppDelegate.delegate().window?.layer.add(animation, forKey: "animation")
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
        
        let leftDrawer = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController")
        
        let flagFirstTime = UserDefaults.standard.bool(forKey: "OpenFirstTime")
        
        var viewController:UINavigationController?
        
        if flagFirstTime == false {
            // Show Tutorial
            UserDefaults.standard.set(true, forKey: "OpenFirstTime")
            UserDefaults.standard.synchronize()
            
            //            viewController = storyboard.instantiateViewControllerWithIdentifier("TutorialContainer") as? UINavigationController
            
            let center = storyboard.instantiateViewController(withIdentifier: "WLCTutorialVC")
            viewController =   UINavigationController(rootViewController: center)
            
            
        }else{
            // show Home
            
            viewController = storyboard.instantiateViewController(withIdentifier: "HomeMenuContainerNew") as? UINavigationController
            
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
    
    fileprivate func setupLogger() {
        #if DEBUG
            LogManager.setup(.Debug)
        #else
            LogManager.setup(.error)
        #endif
    }
    
    
}


extension RangeReplaceableCollection where Iterator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
}





