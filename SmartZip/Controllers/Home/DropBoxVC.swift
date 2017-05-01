//
//  DropBoxVC.swift
//  SwiftExample
//
//  Created by Pawan Dhawan on 18/06/16.
//
//

import UIKit
import SSZipArchive

class DropBoxVC:  UIViewController, UITableViewDelegate, UITableViewDataSource,DBRestClientDelegate {
    
    @IBOutlet weak var tblFiles: UITableView!
    
    @IBOutlet weak var bbiConnect: UIBarButtonItem!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    
    @IBOutlet weak var bannerAdView: UIView!
    var shared:GADMasterViewController!
    
    var arrayDropboxMetaData = NSMutableArray()
    
    var dropboxMetadata: DBMetadata!
    
    var dbRestClient: DBRestClient!
    
    var currentFilePath = ""
    
    var viewLoadedFirstTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.isNavigationBarHidden = true
        
        tblFiles.delegate = self
        tblFiles.dataSource = self
        
        progressBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(DropBoxVC.handleDidLinkNotification(_:)), name: NSNotification.Name(rawValue: "didLinkToDropboxAccountNotification"), object: nil)
        
        if DBSession.shared().isLinked() {
            bbiConnect.title = "Disconnect"
            initDropboxRestClient()
            
        }else{
            
            connectToDropbox(self)
            
        }
        
        if(!CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            //GADBannerView
            // self.setUpGoogleAds()
            shared = GADMasterViewController.singleton()
            shared.resetAdView(self, andDisplay: bannerAdView)
        }
        tblFiles.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        if !viewLoadedFirstTime {
        //            viewLoadedFirstTime = true
        //        }else if !DBSession.sharedSession().isLinked(){
        //            self.btnBackTapped(self)
        //        }
        
        if (CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            if(shared != nil) {
                shared = nil
            }
            bannerAdView.isHidden = true
        }
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        print("FileListViewController Ad changed")
        for tempView in bannerAdView.subviews {
            tempView.removeFromSuperview()
        }
        self.bannerAdView.addSubview(bannerView)
    }
    
    // MARK: IBAction method implementation
    
    @IBAction func connectToDropbox(_ sender: AnyObject) {
        
        if !DBSession.shared().isLinked() {
            DBSession.shared().link(from: self)
        }
        else {
            DBSession.shared().unlinkAll()
            bbiConnect.title = "Connect"
            dbRestClient = nil
            arrayDropboxMetaData.removeAllObjects()
            dropboxMetadata = nil
            tblFiles.reloadData()
        }
    }
    
    
    @IBAction func performAction(_ sender: AnyObject) {
        
        if !DBSession.shared().isLinked() {
            print("You're not connected to Dropbox")
            return
        }
        
        let actionSheet = UIAlertController(title: "Upload file", message: "Select file to upload", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let uploadTextFileAction = UIAlertAction(title: "Upload text file", style: UIAlertActionStyle.default) { (action) -> Void in
            
            let uploadFilename = "testtext.txt"
            let sourcePath = Bundle.main.path(forResource: "testtext", ofType: "txt")
            let destinationPath = "/"
            self.showProgressBar()
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
            
        }
        
        let uploadImageFileAction = UIAlertAction(title: "Upload image", style: UIAlertActionStyle.default) { (action) -> Void in
            
            let uploadFilename = "nature.jpg"
            let sourcePath = Bundle.main.path(forResource: "nature", ofType: "jpg")
            let destinationPath = "/"
            self.showProgressBar()
            self.dbRestClient.uploadFile(uploadFilename, toPath: destinationPath, withParentRev: nil, fromPath: sourcePath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(uploadTextFileAction)
        actionSheet.addAction(uploadImageFileAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func reloadFiles(_ sender: AnyObject) {
        
        guard CommonFunctions.shared().isNetworkReachable() else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        if !DBSession.shared().isLinked() {
            CommonFunctions.sharedInstance.showAlert(kAlertTitle , message: "Please connect with dropbox first", vc: self)
        }else{
            dbRestClient.loadMetadata("/")
        }
        
    }
    
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        
        if DBSession.shared().isLinked() {
            
            if arrayDropboxMetaData.count == 1 {
                
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.popViewController(animated: true)
                
            }else{
                
                arrayDropboxMetaData.removeLastObject()
                dropboxMetadata = arrayDropboxMetaData.lastObject as! DBMetadata
                tblFiles.reloadData()
                
            }
            
        }else{
            
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    // MARK: UITableview method implementation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        //                if let metadata = arrayDropboxMetaData.lastObject as? DBMetadata {
        //                    return metadata.contents.count
        //                }
        if let metadata = dropboxMetadata {
            return metadata.contents.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCellFile", for: indexPath)
        let currentFile: DBMetadata = dropboxMetadata.contents[indexPath.row] as! DBMetadata
        cell.textLabel?.text = currentFile.filename
        
        if(currentFile.icon == "folder" || currentFile.icon == "folder_app"){
            
            cell.imageView?.image = UIImage(named: "myfolder")
            
        }else{
            
            cell.imageView?.image = UIImage(named: "fileIcon")
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard CommonFunctions.shared().isNetworkReachable() else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
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
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: tempDirectoryTemplate) {
            try! fileManager.removeItem(atPath: tempDirectoryTemplate)
        }
        
        try! fileManager.createDirectory(atPath: tempDirectoryTemplate, withIntermediateDirectories: true, attributes: nil)
        
        return tempDirectoryTemplate
        
    }
    
    
    func handleDidLinkNotification(_ notification: Notification) {
        initDropboxRestClient()
        bbiConnect.title = "Disconnect"
    }
    
    func initDropboxRestClient() {
        
        SwiftSpinner.show("Processing, please wait..")
        
        guard CommonFunctions.shared().isNetworkReachable() else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        
        dbRestClient = DBRestClient(session: DBSession.shared())
        dbRestClient.delegate = self
        dbRestClient.loadMetadata("/")
    }
    
    func restClient(_ client: DBRestClient!, uploadedFile destPath: String!, from srcPath: String!, metadata: DBMetadata!) {
        print("The file has been uploaded.")
        print(metadata.path)
        progressBar.isHidden = true
        dbRestClient.loadMetadata("/")
    }
    
    func restClient(_ client: DBRestClient!, uploadFileFailedWithError error: NSError!) {
        print("File upload failed.")
        print(error.description)
        progressBar.isHidden = true
        SwiftSpinner.hide()
    }
    
    func restClient(_ client: DBRestClient!, uploadProgress progress: CGFloat, forFile destPath: String!, from srcPath: String!) {
        progressBar.progress = Float(progress)
    }
    
    func showProgressBar() {
        progressBar.progress = 0.0
        progressBar.isHidden = false
        
        SwiftSpinner.show("Processing, please wait..")
        
    }
    
    func restClient(_ client: DBRestClient!, loadedMetadata metadata: DBMetadata!) {
        
        SwiftSpinner.hide()
        
        dropboxMetadata = metadata;
        
        arrayDropboxMetaData.add(metadata)
        
        tblFiles.reloadData()
    }
    
    func restClient(_ client: DBRestClient!, loadMetadataFailedWithError error: NSError!) {
        print(error.description)
        SwiftSpinner.hide()
    }
    
    func restClient(_ client: DBRestClient!, loadedFile destPath: String!, contentType: String!, metadata: DBMetadata!) {
        
        SwiftSpinner.hide()
        
        print("The file \(metadata.filename) was downloaded. Content type: \(contentType)")
        progressBar.isHidden = true
        
        let zipPath = "\(currentFilePath).zip"
        CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: currentFilePath, vc: self)
        
        
    }
    
    func restClient(_ client: DBRestClient!, loadFileFailedWithError error: NSError!) {
        print(error.description)
        progressBar.isHidden = true
        SwiftSpinner.hide()
    }
    
    func restClient(_ client: DBRestClient!, loadProgress progress: CGFloat, forFile destPath: String!) {
        progressBar.progress = Float(progress)
        let val:Int = Int(progress * 100)
        print(val)
        SwiftSpinner.show("Processing, please wait..\n\n\(val)%", animated: false)
    }
    
    
    func restClient(_ client: DBRestClient!, loadedThumbnail destPath: String!) {
        
        print(destPath)
    }
    
    func restClient(_ client: DBRestClient!, loadThumbnailFailedWithError error: NSError!) {
        
        print(error.description)
        
    }
    
    func doNothing() {
        
    }
    
}

