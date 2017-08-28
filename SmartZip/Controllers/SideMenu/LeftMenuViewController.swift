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
    //    private var topTableIDs = ["HomeCell","TutorialCell","BuyProCell","RestoreCell","ShareAppCell","RateAppCell","AboutCompany","AboutProduct","EmailCell"]
    fileprivate var topTableIDs = ["HomeCell","TutorialCell","ShareAppCell","RateAppCell","AboutCompany","AboutProduct","EmailCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LeftMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  topTableIDs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: topTableIDs[indexPath.row])
        return cell!
    }
}




// MARK: - UITableViewDelegate
extension LeftMenuViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.topTableViewSelected(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func topTableViewSelected(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let container = SideMenuManager.sharedManager().container
        let identifier  = topTableIDs[indexPath.row]
        
        switch identifier {
        case "HomeCell" :
            let center = (self.storyboard?.instantiateViewController(withIdentifier: "HomeVCNew"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "TutorialCell" :
            //TODO
            let center = (self.storyboard?.instantiateViewController(withIdentifier: "WLCTutorialVC"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "BuyProCell" :
            let center = (self.storyboard?.instantiateViewController(withIdentifier: "BuyProVC"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        case "RestoreCell" :
            let center = self.storyboard?.instantiateViewController(withIdentifier: "BuyProVC") as? BuyProVC
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
            let center = (self.storyboard?.instantiateViewController(withIdentifier: "HistoryVC"))!
            container!.centerViewController =  UINavigationController(rootViewController: center)
            container!.closeDrawerAnimated(true, completion: { (Bool) in
            })
            break
        default: break
            
        }
    }
    
    func openAboutCompanyVC() {
        let container = SideMenuManager.sharedManager().container
        let center = (self.storyboard?.instantiateViewController(withIdentifier: "AboutCompany"))!
        container!.centerViewController =  UINavigationController(rootViewController: center)
        container!.closeDrawerAnimated(true, completion: { (Bool) in
        })
    }
    
    func openAboutProductVC() {
        let container = SideMenuManager.sharedManager().container
        let center = (self.storyboard?.instantiateViewController(withIdentifier: "AboutProduct"))!
        container!.centerViewController =  UINavigationController(rootViewController: center)
        container!.closeDrawerAnimated(true, completion: { (Bool) in
        })
    }
    
    func shareApp() {
        
        let textToShare = "Quick and smart way for zip file management. SmartZip is user friendly app for iPhone. It can easily zip our files and upload/share it on cloud and social media. Its a most useful and fast Zip utility for professional and business persons. It has very interesting features : 1) It can compress files, photos, videos, music into Zip file. 2) You can send zip file by email, messenger, Gmail. 3) Open and extract files from Zip format. 4) Save your zipped files in MyFiles section for future use. 5) Upload your zip files on cloud like Dropbox, Google drive, iCloud drive. So friends what are you waiting for! Use SmartZip be smart !!"
        
        if let myWebsite = URL(string: "https://itunes.apple.com/us/app/smartzip/id1141913794?ls=1&mt=8") {
            
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            //            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            //
            
            if let popoverPresentationController = activityVC.popoverPresentationController {
                popoverPresentationController.sourceView = self.view
                var rect=self.view.frame
                rect.origin.y = rect.height
                popoverPresentationController.sourceRect = rect
            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["admin@mobirizer.com"])
            mail.setSubject("SmartZip - Feedback to Admin")
            mail.setMessageBody("<p>Dear Admin</p>", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            // show failure alert
            self.showAlertViewWithMessage("Error", message: Constants.UserMessages.missingEmail)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func contactAdmin() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let webActionButton: UIAlertAction = UIAlertAction(title: "View Website", style: .default)
        { action -> Void in
            
            let url:URL? = URL(string: "http://www.SmartZip.com.au/")
            UIApplication.shared.openURL(url!)
            
        }
        actionSheetController.addAction(webActionButton)
        
        
        let feedbackActionButton: UIAlertAction = UIAlertAction(title: "Give Feedback", style: .default)
        { action -> Void in
            
            self.sendEmail()
            
        }
        actionSheetController.addAction(feedbackActionButton)
        
        
        let callActionButton: UIAlertAction = UIAlertAction(title: " Call Admin", style: .default)
        { action -> Void in
            self.callNumber("0450 663 654")
        }
        actionSheetController.addAction(callActionButton)
        
        if let popoverPresentationController = actionSheetController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = self.topTableView.frame
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    fileprivate func callNumber(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string:"tel://"+"\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
}



