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
    
    private var topTableIDs = ["HomeCell","TutorialCell","BuyProCell","RestoreCell","ShareAppCell","RateAppCell","EmailCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // self.topTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LeftMenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topTableIDs.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(topTableIDs[indexPath.row])
        return cell!
    }
}




// MARK: - UITableViewDelegate
extension LeftMenuViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            //sideMenuViewController?.contentViewController = UINavigationController(rootViewController: (self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as? FirstViewController)!)
            sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController")
            sideMenuViewController?.hideMenuViewController()
            break
        case 1:
            //sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PasscodeVC")
            //sideMenuViewController?.hideMenuViewController()
             break
        case 2:
            break
        case 3:
            break
        case 4:
            
            break
        default:
            break
        }
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.topTableViewSelected(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func topTableViewSelected(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let container = SideMenuManager.sharedManager().container
        let identifier  = topTableIDs[indexPath.row]
        
        switch identifier {
        case "Home" :
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("EventFeedViewController"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "HelpCell" : break
            //TODO
            
        case "BuyProCell" : break
        //TODO
        case "RestoreCell" : break
        //TODO
        case "PasswordCell" :
            container!.closeDrawerAnimated(true, completion: { (Bool) in
                let passcodeVC : PasscodeVC = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("PasscodeVC") as! PasscodeVC
                self.presentViewController(passcodeVC, animated: true, completion: nil)
            })
            break
        //TODO
        case "ShareAppCell" : break
        //TODO
        case "RateAppCell" : break
        //TODO
        case "EmailCell" : break
        //TODO
        case "TutorialCell" : break
        //TODO
        default: break
            
        }
    }
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["nathan@SmartZip.com.au"])
            mail.setSubject("Holiday Happenings - Feedback to Admin")
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
   */
}



