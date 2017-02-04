//
//  MailManager.swift
//  MailManager
//
//  Created by Preeti Bhatia on 03/05/16.
//  Copyright © 2016 Preeti Bhatia. All rights reserved.
//

import Foundation
import MessageUI

let title = "Could Not Send Email"
let message = "Your device could not send e-mail. Please check e-mail configuration and try again."


class MailManager: NSObject, MFMailComposeViewControllerDelegate {
    
    
    var mailComposerVC: MFMailComposeViewController!
    
    weak var delegate:MFMailComposeViewControllerDelegate?
    
    /**
     Initialize MFMailComposeViewController to provides an interface for sending email.
     @discussion  The MFMailComposeViewController class
     
     - parameter subject:        subject
     - parameter body:           body
     - parameter recipients:     recipients
     - parameter image:          UIImage
     - parameter viewcontroller: UIViewController
     */
    func configuredMailComposeViewController(subject: String, body: String, recipients: [String], image: UIImage, imageURL:String, viewcontroller:UIViewController,completion:((response: AnyObject?, error: NSError?) -> Void)?) {
        
        var error: NSError? = nil
        
        if MFMailComposeViewController.canSendMail() {
            
            
            mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            
            //mailComposerVC.navigationBar.tintColor = UIColor.greenColor()
            mailComposerVC.setSubject(subject)
            //            mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(image, 0.5)!, mimeType: "image/png", fileName:  StringConstants.WorkoutSummaryFileName)
            
            mailComposerVC.setToRecipients(recipients)
//            let aStr = String(format:"<p>I just crushed this workout:</p><br><img src= \'%@'><br><p>Want a workout app actually worth using? <a href=%@>%@</a></p>", imageURL, StringConstants.GetStackAppDomain,"Click here to check out STACKED. It's free.")
            
            //mailComposerVC.setMessageBody(aStr, isHTML: true)
            viewcontroller.presentViewController(mailComposerVC, animated: true, completion:nil)
            
            if let block = completion {
                block(response:MFMailComposeViewController.canSendMail(), error:error)
            }
        }
        else {
            //            showSendMailErrorAlert()
            error = NSError(domain: "somedomain", code: 123, userInfo: nil)
            if let block = completion {
                block(response:false, error:error)
            }
            
        }
    }
    
    
    func configuredFeedBackMail(viewcontroller:UIViewController,completion:((response: AnyObject?, error: NSError?) -> Void)?) {
        
        var error: NSError? = nil
        
        if MFMailComposeViewController.canSendMail() {
            
            
            mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            
            mailComposerVC.navigationBar.tintColor = UIColor.redColor()
            
            mailComposerVC.setSubject("")
            //            mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(image, 0.5)!, mimeType: "image/png", fileName:  StringConstants.WorkoutSummaryFileName)
            
            mailComposerVC.setToRecipients(["pawan.kumar@Modi.iin"])
            viewcontroller.presentViewController(mailComposerVC, animated: true, completion:nil)
            
            if let block = completion {
                block(response:MFMailComposeViewController.canSendMail(), error:error)
            }
        }
        else {
            //            showSendMailErrorAlert()
            error = NSError(domain: "somedomain", code: 123, userInfo: nil)
            if let block = completion {
                block(response:false, error:error)
            }
            
        }
    }

    
    
    
    //MARK:
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        //self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result {
        case .Cancelled:
            print("Mail cancelled")
        case .Saved:
            print("Mail saved")
        case .Sent:
            print("Mail sent")
        case .Failed:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
