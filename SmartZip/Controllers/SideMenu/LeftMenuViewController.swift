//
//  LeftMenuViewController.swift
//  SmartZip
//
//  Created by Pawan Kumar on 16/06/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit
import MMDrawerController
import MessageUI



class LeftMenuViewController: UIViewController ,MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var topTableView: UITableView!
    private var topTableIDs = ["HomeCell","TutorialCell","BuyProCell","RestoreCell","ShareAppCell","RateAppCell","AboutCompany","AboutProduct","EmailCell"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.topTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LeftMenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  topTableIDs.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(topTableIDs[indexPath.row])
        return cell!
    }
}




// MARK: - UITableViewDelegate
extension LeftMenuViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.topTableViewSelected(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func topTableViewSelected(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let container = SideMenuManager.sharedManager().container
        let identifier  = topTableIDs[indexPath.row]
        
        switch identifier {
        case "HomeCell" :
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("HomeVCNew"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "TutorialCell" :
            //TODO
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("TutorialVC"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "BuyProCell" :
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("BuyProVC"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "RestoreCell" :
            let center = self.storyboard?.instantiateViewControllerWithIdentifier("BuyProVC") as? BuyProVC
            container!.centerViewController =  UINavigationController(rootViewController: center!)
            center!.isShowRestoreBtn = true
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            
            break
        //TODO
        case "PasswordCell" :
            container!.closeDrawerAnimated(true, completion: { (Bool) in
                let passcodeVC : PasscodeVC = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("PasscodeVC") as! PasscodeVC
                self.presentViewController(passcodeVC, animated: true, completion: nil)
                //self.navigationController?.pushViewController(passcodeVC, animated: true)
            })
            break
        //TODO
        case "ShareAppCell" :
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            self.shareApp()
            break
        case "RateAppCell" :
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            iRate.sharedInstance().openRatingsPageInAppStore()
            break
        case "AboutCompany" :
            self.openAboutCompanyVC();
            break
        case "AboutProduct" :
            self.openAboutProductVC();
            break
        case "EmailCell" :
            self.sendEmail();
            break
        case "HistoryCell" :
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("HistoryVC"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        default: break
            
        }
    }
    
    func openAboutCompanyVC() {
        let container = SideMenuManager.sharedManager().container
        let center = (self.storyboard?.instantiateViewControllerWithIdentifier("AboutCompany"))!
        container!.centerViewController =  UINavigationController(rootViewController: center)
        container!.closeDrawerAnimated(true, completion: { (Bool) in
        })
    }
    
    func openAboutProductVC() {
        let container = SideMenuManager.sharedManager().container
        let center = (self.storyboard?.instantiateViewControllerWithIdentifier("AboutProduct"))!
        container!.centerViewController =  UINavigationController(rootViewController: center)
        container!.closeDrawerAnimated(true, completion: { (Bool) in
        })
    }
    
    func shareApp() {
        
        let textToShare = "I love this app."
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/") {
            
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypeMessage]
            //      
            
            if let popoverPresentationController = activityVC.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                var rect=self.view.frame
                rect.origin.y = rect.height
                popoverPresentationController.sourceRect = rect
            }
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["admin@mobirizer.com"])
            mail.setSubject("Smart Zip - Feedback to Admin")
            mail.setMessageBody("<p>Dear Admin</p>", isHTML: true)
            presentViewController(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            self.showAlertViewWithMessage("Error", message: Constants.UserMessages.missingEmail)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func contactAdmin() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheetController.view.tintColor = UIColor.blackColor()
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let webActionButton: UIAlertAction = UIAlertAction(title: "View Website", style: .Default)
        { action -> Void in
            
            let url:NSURL? = NSURL(string: "http://www.SmartZip.com.au/")
            UIApplication.sharedApplication().openURL(url!)
            
        }
        actionSheetController.addAction(webActionButton)
        
        
        let feedbackActionButton: UIAlertAction = UIAlertAction(title: "Give Feedback", style: .Default)
        { action -> Void in
            
            self.sendEmail()
            
        }
        actionSheetController.addAction(feedbackActionButton)
        
        
        let callActionButton: UIAlertAction = UIAlertAction(title: " Call Admin", style: .Default)
        { action -> Void in
            self.callNumber("0450 663 654")
        }
        actionSheetController.addAction(callActionButton)
        
        if let popoverPresentationController = actionSheetController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = self.topTableView.frame
        }
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://"+"\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
}



