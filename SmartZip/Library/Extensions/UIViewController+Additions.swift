//
//  UIViewController+Additions.swift
//
//  Created by Pawan Joshi on 12/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit

// MARK: - UIViewController Extension
extension UIViewController {
    
    /**
     Shows a simple alert view with a title and dismiss button
     
     - parameter title:   title for alerview
     - parameter message: message to be shown
     */
    func showAlertViewWithMessage(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     Shows a simple alert banner with a title and dismiss button
     
     - parameter title:   title for alerview
     - parameter message: message to be shown
     */
    func showAlertBannerWith(title: String, message: String, bannerStyle:ALAlertBannerStyle, timeDurationInSeconds:NSTimeInterval) {
        
        let bannerAlertPosition = ALAlertBannerPositionBottom
        let banner = ALAlertBanner(forView: self.view, style: bannerStyle, position: bannerAlertPosition, title: title, subtitle: message)
        banner.secondsToShow = timeDurationInSeconds
    }
    
    /**
     Shows a simple alert banner with auto hide
    
     - parameter message:     message description
     - parameter bannerStyle: bannerStyle description
     */
    func showAlertBannerWithMessage(message: String, bannerStyle:ALAlertBannerStyle) {
        
        let bannerAlertPosition = ALAlertBannerPositionTop
        let banner = ALAlertBanner(forView: self.view, style: bannerStyle, position: bannerAlertPosition, title: message)
        banner.show()
    }
    
    /**
     Shows a simple alert view with a title, dismiss button and action handler for dismiss button
     
     - parameter title:         title for alerview
     - parameter message:       message description
     - parameter actionHandler: actionHandler code/closer/block
     */
    func showAlertViewWithMessageAndActionHandler(title: String, message: String, actionHandler:(() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default) { (action) in
            
            if let _ = actionHandler {
                actionHandler!()
            }
        }
        alertController.addAction(alAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     Shows a simple alert view with a simple text field
     
     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithTextField(title: String, message: String, textFieldPlaceholder:String, submitActionHandler:(textFromTextField:String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = textFieldPlaceholder
            textField.borderStyle = UITextBorderStyle.None
        }
        
        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .Default) {  (action: UIAlertAction!) in
            let answerTF = alertController.textFields![0]
            let text = answerTF.text
            submitActionHandler(textFromTextField: text)
        }
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) {  (action: UIAlertAction!) in

        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     Shows a simple alert view with a secure text field
     
     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithSecureTextField(title: String, message: String, textFieldPlaceholder:String, submitActionHandler:(textFromTextField:String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = textFieldPlaceholder
            textField.secureTextEntry = true
        }
        
        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .Default) {  (action: UIAlertAction!) in
            let answer = alertController.textFields![0]
            submitActionHandler(textFromTextField: answer.text!)
        }
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .Cancel) {  (action: UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    /**
     shows activity controller with supplied items. at least one type of item must be supplied
     
     - parameter image:      image to be shared
     - parameter text:       text to be shared
     - parameter url:        url to be shared
     - parameter activities: array of UIActivity which you want to show in controller. nil value will show every available active by default
     */
    func showActivityController(image: UIImage?, text: String?, url: String?, activities: [UIActivity]? = nil ) {
        
        var array = [AnyObject]()
        
        if image != nil {
            array.append(image!)
        }
        if text != nil {
            array.append(text!)
        }
        if url != nil {
            array.append(NSURL(string: url!)!)
        }
        assert(array.count != 0, "Please specify at least element to share among image, text or url")
        
        let activityController = UIActivityViewController(activityItems: array, applicationActivities: activities)
        presentViewController(activityController, animated: true, completion: nil)
    }
}