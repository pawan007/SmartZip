//
//  LeftMenuViewController.swift
//  HolidayHappenings
//
//  Created by Pawan Joshi on 13/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import MMDrawerController
import MessageUI
import SCLAlertView

let goPremiumVCStoryboardId :String = "goPremiumViewController"


class LeftMenuViewController: UIViewController ,MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var botTableView: UITableView!
    
    private var topTableIDs = ["EventFeedCell","ChangePasswordCell","GoPremiumCell","FavouritesCell"]//,"NotificationsCell"
    private var botomTableIDs = ["ContactAdminCell","AboutCell","TermsConditionsCell","LogoutCell"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = UserManager.sharedManager().activeUser
        
        if (user != nil) {
            topTableIDs = ["EventFeedCell","NotificationsCell","ChangePasswordCell","GoPremiumCell","FavouritesCell"]
            botomTableIDs = ["ContactAdminCell","AboutCell","TermsConditionsCell","LogoutCell"]
        }
        else {
            topTableIDs = ["EventFeedCell","GoPremiumCell"]//,"NotificationsCell"
            botomTableIDs = ["ContactAdminCell","AboutCell","TermsConditionsCell","LoginCell"]
        }
        self.topTableView.reloadData()
        self.botTableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LeftMenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==topTableView {
            return  topTableIDs.count
        }
        else {
            return  botomTableIDs.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView==topTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier(topTableIDs[indexPath.row])
            //cell!.selectionStyle = .None
            
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(botomTableIDs[indexPath.row])
            //cell!.selectionStyle = .None
            
            return cell!
        }
        
    }
}


extension LeftMenuViewController {
    /**
     Release all user info.
     */
    private func logout()
    {
        let container = SideMenuManager.sharedManager().container
        
        let alertController = UIAlertController(title: nil, message: "Are you sure ?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.restorationIdentifier = "LogoutMenuContainer"
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Logout", comment: "Logout"), style: UIAlertActionStyle.Destructive, handler: { (action) -> Void in
            // Handle Logout
            // show loader
            SideMenuManager.sharedManager().container?.view.showLoader(mainTitle: NSLocalizedString("Logging Out", comment: "Logging Out"), subTitle: NSLocalizedString("Just a moment...", comment: ""))
            UserManager.sharedManager().performLogout({ (success, error) -> (Void) in
                
                SideMenuManager.sharedManager().container?.view.hideLoader()
                
                if(error == nil)
                {
                // perform clean up
                    UserManager.sharedManager().deleteActiveUser()
                    SideMenuManager.sharedManager().container = nil
                    // AppDelegate.presentRootViewController(true)
                    let loginView : UIViewController = AppDelegate.rootViewController()
                    AppDelegate.delegate().window?.rootViewController = loginView
                }
                else
                {
                    let description : String = (error?.localizedFailureReason)!
                    SCLAlertView().showError("Error", subTitle: description)
                }
                
                //if error != nil {
                //self.showAlertBannerWithMessage((error!.localizedFailureReason)!, bannerStyle: ALAlertBannerStyleFailure)
                //}
            })
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        if let popoverPresentationController = alertController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            var  popoverFrame : CGRect = self.botTableView.frame
            popoverFrame.origin.y += self.botTableView.frame . height - 40
            popoverPresentationController.sourceRect = popoverFrame
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension LeftMenuViewController: UITableViewDelegate
{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == topTableView {
            self.topTableViewSelected(tableView, didSelectRowAtIndexPath: indexPath)
        }
        else {
            self.bottomTableViewSelected(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    func topTableViewSelected(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let container = SideMenuManager.sharedManager().container
        let identifier  = topTableIDs[indexPath.row]
        
        switch identifier {
        case "EventFeedCell" :
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("EventFeedViewController"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "NotificationsCell" :
            //TODO
            
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("NotificationViewController"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "ChangePasswordCell" :
            //TODO
            container!.closeDrawerAnimated(true, completion: { (Bool) in
                let changePassword : ChangePasswordViewController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier("ChangePasswordVC") as! ChangePasswordViewController
               
               // changePassword.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
 
                self.presentViewController(changePassword, animated: true, completion: nil)
            })
            
            break
        case "GoPremiumCell" :
             container!.closeDrawerAnimated(true, completion: { (Bool) in
            let goPremiumVC : UIViewController = UIStoryboard.mainStoryboard().instantiateViewControllerWithIdentifier(goPremiumVCStoryboardId)
            self.presentViewController(goPremiumVC, animated: true, completion: nil)
                })
            break
        case "FavouritesCell" :
            let center = (self.storyboard?.instantiateViewControllerWithIdentifier("FavouriteFeedsViewController"))!
            container!.centerViewController =   UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        default: break
            
        }
    }
    
    func bottomTableViewSelected(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let container = SideMenuManager.sharedManager().container
        let identifier  = botomTableIDs[indexPath.row]
        if identifier == NSLocalizedString("Logout", comment: "Logout") {
            logout()
        }
        else {
            switch identifier {
            case "ContactAdminCell" :
                //TODO
                self.contactAdmin()
                break
            case "AboutCell" :
                container?.closeDrawerAnimated(true, completion: { (true) in
                    let eulaVC:EULAWebController = EULAWebController(nibName: "EULAWebController", bundle: NSBundle.mainBundle())
                    eulaVC.title = "About Us"
                    self.presentViewController(eulaVC, animated: true, completion: nil)
                })
                break
            case "TermsConditionsCell" :
                //TODO
                container?.closeDrawerAnimated(true, completion: { (true) in
                let eulaVC:EULAWebController = EULAWebController(nibName: "EULAWebController", bundle: NSBundle.mainBundle())
                eulaVC.title = "Terms and Conditions"
                self.presentViewController(eulaVC, animated: true, completion: nil)
                    })
                break
      
            case "LogoutCell" :
                //TODO
                self.logout()
                //container?.centerViewController!.view.showLoader(mainTitle: nil, subTitle: nil)
                /*
                self.dismissViewControllerAnimated(true, completion: {
                    
                })
                
                container!.closeDrawerAnimated(true, completion: { (Bool) in
                    UserManager.sharedManager().performLogout({ (success, error) -> (Void) in
                        container?.centerViewController!.view.hideLoader()
                        if((error) != nil)
                        {
                            UserManager.sharedManager().deleteActiveUser()
                            self.dismissViewControllerAnimated(true, completion: {
                                
                            })
                        }
                        else
                        {
                            // Show an alert here
                        }
                    })
                })
                */
                break
              case "LoginCell" :
                   //TODO pls call login page
                container?.closeDrawerAnimated(true, completion: { (true) in
                    let loginView : UIViewController = AppDelegate.rootViewController()
                    AppDelegate.delegate().window?.rootViewController = loginView
                })
                
                break
                
            default: break
                
            }
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["nathan@holidayhappenings.com.au"])
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
            
            let url:NSURL? = NSURL(string: "http://www.holidayhappenings.com.au/")
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
            popoverPresentationController.sourceRect = self.botTableView.frame
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

/*      // Do any additional setup after loading the view.
 
 if let user = UserManager.sharedManager().activeUser {
 self.userNameLabel.text = user.fullName()
 if let thumbImageUrl = user.thumbImageUrl {
 self.profileImageView.sd_setImageWithURL(NSURL(string: thumbImageUrl), placeholderImage: UIImage(named: "ProfilePicBlank"))
 }
 }*/