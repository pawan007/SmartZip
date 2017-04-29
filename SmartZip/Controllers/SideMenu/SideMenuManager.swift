//
//  SideMenuManager.swift
//  SmartZip
//
//  Created by Pawan Kumar on 13/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit
import MMDrawerController

/// Side Menu manager to provide sibgle instanse om side manager
class SideMenuManager: NSObject {
    
    // MARK: - Singleton Instance
    fileprivate static let _sharedManager = SideMenuManager()
    
    var container: MMDrawerController? = MMDrawerController()
    var center: UIViewController {
        get {
            container!.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.none

            if container!.centerViewController.isKind(of:UINavigationController.self) {
                return (container!.centerViewController as! UINavigationController).viewControllers.first!
            }
            return container!.centerViewController
        }
    }
    
    fileprivate override init() {
        super.init()
    }
    
    /**
     Set container properties.
     
     - parameter block: drawer object
     */
    func setValues(_ block: (MMDrawerController)->()) {
        assert(container != nil, "Container(Drawer) must be set")
        block(container!)
    }
    
    // MARK: - Singleton Method
    class func sharedManager() -> SideMenuManager {
        if _sharedManager.container == nil {
            _sharedManager.container = MMDrawerController()
            _sharedManager.container!.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionMode.none
            /*
             
             Note that either `openDrawerGestureModeMask` must contain `MMOpenDrawerGestureModeCustom`, or `closeDrawerGestureModeMask` must contain `MMCloseDrawerGestureModeCustom` for this block to be consulted.

             
             */

            _sharedManager.container!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.custom
            _sharedManager.container!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.custom
            
            _sharedManager.container?.setGestureShouldRecognizeTouch({ (drawer, recog, touch) -> Bool in
               return false
            })
            
            //MMDrawerOpenCenterInteractionModeNavigationBarOnly
        }
        return _sharedManager
    }
}
