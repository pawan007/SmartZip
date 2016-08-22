//
//  DropBoxVC.swift
//  SwiftExample
//
//  Created by Pawan Dhawan on 18/06/16.
//
//

import UIKit
import SSZipArchive
import SwiftSpinner

class DropBoxVC:  UIViewController, UITableViewDelegate, UITableViewDataSource,DBRestClientDelegate {
    
    @IBOutlet weak var tblFiles: UITableView!
    
    @IBOutlet weak var bbiConnect: UIBarButtonItem!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var arrayDropboxMetaData = NSMutableArray()
    
    var dropboxMetadata: DBMetadata!
    
    var dbRestClient: DBRestClient!
    
    var currentFilePath = ""
    
    var viewLoadedFirstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBarHidden = true
        
        tblFiles.delegate = self
        tblFiles.dataSource = self
        
        progressBar.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DropBoxVC.handleDidLinkNotification(_:)), name: "didLinkToDropboxAccountNotification", object: nil)
        
        if DBSession.sharedSession().isLinked() {
            bbiConnect.title = "Disconnect"
            initDropboxRestClient()
        }else{
            
            connectToDropbox(self)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //        if !viewLoadedFirstTime {
        //            viewLoadedFirstTime = true
        //        }else if !DBSession.sharedSession().isLinked(){
        //            self.btnBackTapped(self)
        //        }
        
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func connectToDropbox(sender: AnyObject) {
        
        if !DBSession.sharedSession().isLinked() {
            DBSession.sharedSession().linkFromController(self)
        }
        else {
            DBSession.sharedSession().unlinkAll()
            bbiConnect.title = "Connect"
            dbRestClient = nil
            arrayDropboxMetaData.removeAllObjects()
            dropboxMetadata = nil
            tblFiles.reloadData()
        }
    }
    
    
    @IBAction func performAction(sender: AnyObject) {
        
        if !DBSession.sharedSession().isLinked() {
            print("You're not connected to Dropbox")
            return
        }
        
        let actionSheet = UIAlertController(title: "Upload file", message: "Select file to upload", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let uploadTextFileAction = UIAlertAction(title: "Upload text file", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let uploadFilename = "testtext.txt"
            let sourcePath = NSBundle.mainBundle().pathForResource("testtext", ofType: "txt")
            let destinationPath = "/"
            self.showProgressBar()
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
            
        }
        
        let uploadImageFileAction = UIAlertAction(title: "Upload image", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let uploadFilename = "nature.jpg"
            let sourcePath = NSBundle.mainBundle().pathForResource("nature", ofType: "jpg")
            let destinationPath = "/"
            self.showProgressBar()
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(uploadTextFileAction)
        actionSheet.addAction(uploadImageFileAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func reloadFiles(sender: AnyObject) {
        dbRestClient.loadMetadata("/")
    }
    
    
    @IBAction func btnBackTapped(sender: AnyObject) {
        
        if DBSession.sharedSession().isLinked() {
            
            if arrayDropboxMetaData.count == 1 {
                
                self.navigationController?.navigationBarHidden = false
                self.navigationController?.popViewControllerAnimated(true)
                
            }else{
                
                arrayDropboxMetaData.removeLastObject()
                dropboxMetadata = arrayDropboxMetaData.lastObject as! DBMetadata
                tblFiles.reloadData()
                
            }
            
        }else{
            
            self.navigationController?.navigationBarHidden = false
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    
    // MARK: UITableview method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        //                if let metadata = arrayDropboxMetaData.lastObject as? DBMetadata {
        //                    return metadata.contents.count
        //                }
        if let metadata = dropboxMetadata {
            return metadata.contents.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellFile", forIndexPath: indexPath)
        let currentFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        cell.textLabel?.text = currentFile.filename
        
        if(currentFile.icon == "folder" || currentFile.icon == "folder_app"){
            
            cell.imageView?.image = UIImage(named: "folderIcon")
            
        }else{
            
            cell.imageView?.image = UIImage(named: "fileIcon")
            
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let selectedFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        if(selectedFile.icon == "folder" || selectedFile.icon == "folder_app"){
            
            SwiftSpinner.show("Processing, please wait..")
            dbRestClient.loadMetadata(selectedFile.path)
            
        }else{
            
            let exactPath = "\(CommonFunctions.sharedInstance.docDirPath())/\(selectedFile.filename)"
            currentFilePath = exactPath
            showProgressBar()
            dbRestClient.loadFile(selectedFile.path, intoPath: exactPath as String)
            
        }
        
    }
    
    func createTempDirectory() -> String? {
        
        let tempDirectoryTemplate = "\(NSTemporaryDirectory())/thumbnails"
        
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(tempDirectoryTemplate) {
            try! fileManager.removeItemAtPath(tempDirectoryTemplate)
        }
        
        try! fileManager.createDirectoryAtPath(tempDirectoryTemplate, withIntermediateDirectories: true, attributes: nil)
        
        return tempDirectoryTemplate
        
    }
    
    
    func handleDidLinkNotification(notification: NSNotification) {
        initDropboxRestClient()
        bbiConnect.title = "Disconnect"
    }
    
    func initDropboxRestClient() {
        
        SwiftSpinner.show("Processing, please wait..")
        
        dbRestClient = DBRestClient(session: DBSession.sharedSession())
        dbRestClient.delegate = self
        dbRestClient.loadMetadata("/")
    }
    
    func restClient(client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        print("The file has been uploaded.")
        print(metadata.path)
        progressBar.hidden = true
        dbRestClient.loadMetadata("/")
    }
    
    func restClient(client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        print("File upload failed.")
        print(error.description)
        progressBar.hidden = true
        SwiftSpinner.hide()
    }
    
    func restClient(client: DBRestClient!, uploadProgress progress: CGFloat, forFile destPath: String!, from srcPath: String!) {
        progressBar.progress = Float(progress)
    }
    
    func showProgressBar() {
        progressBar.progress = 0.0
        progressBar.hidden = false
        
        SwiftSpinner.show("Processing, please wait..")
        
    }
    
    func restClient(client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
        
        SwiftSpinner.hide()
        
        dropboxMetadata = metadata;
        
        arrayDropboxMetaData.addObject(metadata)
        
        tblFiles.reloadData()
    }
    
    func restClient(client: DBRestClient!, loadMetadataFailedWithError error: NSError!) {
        print(error.description)
        SwiftSpinner.hide()
    }
    
    func restClient(client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!) {
        
        SwiftSpinner.hide()
        
        print("The file \(metadata.filename) was downloaded. Content type: \(contentType)")
        progressBar.hidden = true
        
        let zipPath = "\(currentFilePath).zip"
        CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: currentFilePath, vc: self)
        
        
    }
    
    func restClient(client: DBRestClient!, loadFileFailedWithError error: NSError!) {
        print(error.description)
        progressBar.hidden = true
        SwiftSpinner.hide()
    }
    
    func restClient(client: DBRestClient!, loadProgress progress: CGFloat, forFile destPath: String!) {
        progressBar.progress = Float(progress)
        let val:Int = Int(progress * 100)
        print(val)
        SwiftSpinner.show("Processing, please wait..\n\n\(val)%", animated: false)
    }
    
    
    func restClient(client: DBRestClient!, loadedThumbnail destPath: String!) {
        
        print(destPath)
    }
    
    func restClient(client: DBRestClient!, loadThumbnailFailedWithError error: NSError!) {
        
        print(error.description)
        
    }
    
    func doNothing() {
        
    }
    
}

