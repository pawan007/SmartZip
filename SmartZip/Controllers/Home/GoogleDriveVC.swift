//
//  GoogleDriveVC.swift
//  TestGoogleDrive
//
//  Created by Pawan Dhawan on 08/07/16.
//  Copyright © 2016 Pawan Dhawan. All rights reserved.
//

import UIKit
import GoogleAPIClient
import GTMOAuth2
import SwiftSpinner

class GoogleDriveVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let kKeychainItemName = "Drive API"
    private let kClientID = "250150690669-f40jbqpnvvd4sjeui1id07507ds4hvcq.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLAuthScopeDriveFile, kGTLAuthScopeDriveReadonly, kGTLAuthScopeDrive]
    
    private let service = GTLServiceDrive()
    //    let output = UITextView()
    
    // Data model: These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    var files:[GTLDriveFile] = []
    
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    var strFileList = ""
    
    // When the view loads, create necessary subviews
    // and initialize the Drive API service
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*output.frame = view.bounds
         output.editable = false
         output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
         output.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
         
         view.addSubview(output);*/
        
        // Register the table view cell class and its reuse id
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Google Drive"
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
            service.authorizer = auth
        }
        
        
    }
    
    // When the view appears, ensure that the Drive API service is authorized
    // and perform API calls
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            fetchFiles()
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }
    
    // Construct a query to get names and IDs of 10 files using the Google Drive API
    func fetchFiles() {
        //        output.text = "Getting files..."
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        SwiftSpinner.show("Processing, please wait..")
        let query = GTLQueryDrive.queryForFilesList()
        query.pageSize = 1000
        query.fields = "nextPageToken, files(id, name, mimeType, iconLink)"
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: #selector(GoogleDriveVC.displayResultWithTicket(_:finishedWithObject:error:))
        )
    }
    
    // Construct a query to get names and IDs of 10 files using the Google Drive API
    func fetchAnptherListFiles(token:String) {
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        //        output.text = "Getting files..."
        let query = GTLQueryDrive.queryForFilesList()
        query.pageToken = token
        query.pageSize = 50
        query.fields = "nextPageToken, files(id, name, mimeType, iconLink)"
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: #selector(GoogleDriveVC.displayResultWithTicket(_:finishedWithObject:error:))
        )
        
    }
    
    
    // Construct a query to get names and IDs of 10 files using the Google Drive API
    func fetchFolderFiles(folderId:String) {
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        let query = GTLQueryDrive.queryForFilesGetWithFileId(folderId)
        query.q = "\(folderId) IN parents"
        //        query.pageSize = 50
        //        query.fields = "nextPageToken, files(id, name, mimeType, iconLink)"
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: #selector(GoogleDriveVC.displayResultWithTicket(_:finishedWithObject:error:))
        )
        
    }
    
    // Parse results and display
    func displayResultWithTicket(ticket : GTLServiceTicket,
                                 finishedWithObject response : GTLDriveFileList,
                                                    error : NSError?) {
        
        SwiftSpinner.hide()
        
        if let error = error {
            showAlert("Error", message: error.localizedDescription)
            return
        }
        
        var filesString = ""
        
        //        self.files.removeAll()
        //        tableView.reloadData()
        
        if let files = response.files where !files.isEmpty {
            
            
            self.files = files as! [GTLDriveFile]
            tableView.reloadData()
            
            
            filesString += "Files:\n"
            for file in files as! [GTLDriveFile] {
                //                filesString += "\(file.name) (\(file.identifier))\n"
                filesString += "\(file.name)\n"
                if (file.mimeType != nil) {
                    print(file.mimeType)
                }
                print(file.iconLink)
            }
        } else {
            filesString = "No files found."
        }
        
        //        output.text = filesString
        
        if (response.nextPageToken != nil) {
            //            strFileList = "\(strFileList) \n \(output.text)"
            fetchAnptherListFiles(response.nextPageToken)
        }else{
            
            //            strFileList = "\(strFileList) \n \(output.text)"
            //            output.text = strFileList
        }
        
        
        
        
    }
    
    
    
    
    // Creates the auth controller for authorizing access to Drive API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: #selector(GoogleDriveVC.viewController(_:finishedWithAuth:error:))
        )
    }
    
    // Handle completion of the authorization process, and update the Drive API
    // with the new credentials.
    func viewController(vc : UIViewController,
                        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
        
        if let error = error {
            service.authorizer = nil
            showAlert("Authentication Error", message: error.localizedDescription)
            return
        }
        
        service.authorizer = authResult
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            var rect=self.view.frame
            rect.origin.y = rect.height
            popoverPresentationController.sourceRect = rect
        }
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let file = self.files[indexPath.row] as GTLDriveFile
        cell.imageView?.sd_setImageWithURL(NSURL(string: file.iconLink), placeholderImage: UIImage(named: "folderIcon.png") )
        cell.textLabel?.text = file.name
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        let file = self.files[indexPath.row] as GTLDriveFile
        
        if(file.mimeType == "application/vnd.google-apps.folder"){
            
            //            fetchFolderFiles(file.identifier)
            
        }else if(file.mimeType == "application/vnd.google-apps.spreadsheet" || file.mimeType == "application/vnd.google-apps.presentation" || file.mimeType == "application/vnd.google-apps.document" ){
            
            SwiftSpinner.show("Processing, please wait..")
            
            let file = self.files[indexPath.row] as GTLDriveFile
            let filePath = "https://www.googleapis.com/drive/v3/files/\(file.identifier)/export?alt=media&mimeType=application/pdf"
            let fetcher = self.service.fetcherService.fetcherWithURLString(filePath)
            
            fetcher.beginFetchWithCompletionHandler({ (data, error) -> Void in
                
                SwiftSpinner.hide()
                
                if(error == nil){
                    
                    let exactPath = "\(CommonFunctions.sharedInstance.docDirPath())/\(file.name)"
                    data?.writeToFile(exactPath, atomically: true)
                    let zipPath = "\(exactPath).zip"
                    CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: exactPath, vc: self)
                    
                    
                }else{
                    
                    self.downloadNormalDocument(file)
                    
                }
                
            })
            
        }else{
            
            SwiftSpinner.show("Processing, please wait..")
            
            let filePath = "https://www.googleapis.com/drive/v3/files/\(file.identifier)?alt=media"
            let fetcher = self.service.fetcherService.fetcherWithURLString(filePath)
            
            fetcher.beginFetchWithCompletionHandler({ (data, error) -> Void in
                
                SwiftSpinner.hide()
                
                if(error == nil){
                    
                    //                    data?.writeToFile("\(NSTemporaryDirectory())/\(file.name)", atomically: true)
                    let exactPath = "\(CommonFunctions.sharedInstance.docDirPath())/\(file.name)"
                    data?.writeToFile(exactPath, atomically: true)
                    let zipPath = "\(exactPath).zip"
                    CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: exactPath, vc: self)
                    
                }else{
                    
                    self.downloadExportDocument(file)
                    
                }
                
            })
            
        }
        
    }
    
    
    func downloadExportDocument(file:GTLDriveFile) -> Void {
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        SwiftSpinner.show("Processing, please wait..")
        
        let filePath = "https://www.googleapis.com/drive/v3/files/\(file.identifier)/export?alt=media&mimeType=\(file.mimeType)"
        
        let fetcher = self.service.fetcherService.fetcherWithURLString(filePath)
        
        fetcher.beginFetchWithCompletionHandler({ (data, error) -> Void in
            
            SwiftSpinner.hide()
            
            if(error == nil){
                
                let exactPath = "\(CommonFunctions.sharedInstance.docDirPath())/\(file.name)"
                data?.writeToFile(exactPath, atomically: true)
                let zipPath = "\(exactPath).zip"
                CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: exactPath, vc: self)
                
            }else{
                
                self.showAlert("Failed", message: "Unable to download document")
            }
            
        })
        
    }
    
    func downloadNormalDocument(file:GTLDriveFile) -> Void {
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        SwiftSpinner.show("Processing, please wait..")
        
        let filePath = "https://www.googleapis.com/drive/v3/files/\(file.identifier)?alt=media"
        let fetcher = self.service.fetcherService.fetcherWithURLString(filePath)
        
        fetcher.beginFetchWithCompletionHandler({ (data, error) -> Void in
            
            SwiftSpinner.hide()
            
            if(error == nil){
                
                //                data?.writeToFile("\(NSTemporaryDirectory())/\(file.name)", atomically: true)
                let exactPath = "\(CommonFunctions.sharedInstance.docDirPath())/\(file.name)"
                data?.writeToFile(exactPath, atomically: true)
                let zipPath = "\(exactPath).zip"
                CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: exactPath, vc: self)
                
            }else{
                
                self.showAlert("Failed", message: "Unable to download document")
                
            }
            
        })
        
    }
    
}