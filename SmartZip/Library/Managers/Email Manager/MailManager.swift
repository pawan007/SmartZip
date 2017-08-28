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
    func configuredMailComposeViewController(_ subject: String, body: String, recipients: [String], image: UIImage, imageURL:String, viewcontroller:UIViewController,completion:((_ response: AnyObject?, _ error: NSError?) -> Void)?) {
        
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
            viewcontroller.present(mailComposerVC, animated: true, completion:nil)
            
            if let block = completion {
                block(MFMailComposeViewController.canSendMail() as AnyObject, error)
            }
        }
        else {
            //            showSendMailErrorAlert()
            error = NSError(domain: "somedomain", code: 123, userInfo: nil)
            if let block = completion {
                block(false as AnyObject, error)
            }
            
        }
    }
    
    
    func configuredFeedBackMail(_ viewcontroller:UIViewController,completion:((_ response: AnyObject?, _ error: NSError?) -> Void)?) {
        
        var error: NSError? = nil
        
        if MFMailComposeViewController.canSendMail() {
            
            
            mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            
            mailComposerVC.navigationBar.tintColor = UIColor.red
            
            mailComposerVC.setSubject("")
            //            mailComposerVC.addAttachmentData(UIImageJPEGRepresentation(image, 0.5)!, mimeType: "image/png", fileName:  StringConstants.WorkoutSummaryFileName)
            
            mailComposerVC.setToRecipients(["pawan.kumar@Modi.iin"])
            viewcontroller.present(mailComposerVC, animated: true, completion:nil)
            
            if let block = completion {
                block(MFMailComposeViewController.canSendMail() as AnyObject, error)
            }
        }
        else {
            //            showSendMailErrorAlert()
            error = NSError(domain: "somedomain", code: 123, userInfo: nil)
            if let block = completion {
                block(false as AnyObject, error)
            }
            
        }
    }

    
    
    
    //MARK:
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(error!.localizedDescription)")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
