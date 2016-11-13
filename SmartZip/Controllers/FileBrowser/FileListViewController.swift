//
//  FileListViewController.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner

protocol MoveFileDelegate {
    func cancelMoveFile()
    func successMoveFile()
}

class FileListViewController: UIViewController {
    
    
    @IBOutlet weak var bannerAdView: UIView!
    var shared:GADMasterViewController!
    var lblNoContent:UILabel?
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var normalView: UIView!
    
    @IBOutlet weak var selectAllInEditViewBtn: UIButton!
    @IBOutlet weak var newFolderBtn: UIButton!
    @IBOutlet weak var renameBtn: UIButton!
    //    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var moveBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var zipBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var openInBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    @IBOutlet weak var bottomHeightConstant: NSLayoutConstraint!
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    let collation = UILocalizedIndexedCollation.currentCollation()
    
    /// Data
    var didSelectFile: ((FBFile) -> ())?
    var files = [FBFile]()
    var filesForSharing = [FBFile]()
    var initialPath: NSURL?
    let parser = FileParser.sharedInstance
    let previewManager = PreviewManager()
    var sections: [[FBFile]] = []
    
    var editButton:UIBarButtonItem?
    var doneButton:UIBarButtonItem?
    var cancelButton:UIBarButtonItem?
    
    // Search controller
    var filteredFiles = [FBFile]()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.backgroundColor = UIColor.whiteColor()
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    var flagShowShareOptionOnly = false
    var flagShowEditView = false
    var flagMoveItem = false
    
    var delegate:MoveFileDelegate?
    var moveItemPaths = [NSURL]()
    
    var imageOpenCounter = 0
    var imageCloseCounter = 0
    
    convenience init (initialPath: NSURL) {
        
        //        self.init(nibName: "FileBrowser", bundle: NSBundle(forClass: FileListViewController.self))
        self.init()
        self.edgesForExtendedLayout = .None
        
        // Set initial path
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        
        // Set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        
    }
    
    
    
    deinit{
        if #available(iOS 9.0, *) {
            searchController.loadViewIfNeeded()
        } else {
            searchController.loadView()
        }
    }
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        
        // Prepare data
        self.edgesForExtendedLayout = .None
        
        if  FileParser.sharedInstance.currentPath == nil{
            self.initialPath = FileParser.sharedInstance.documentsURL()
            FileParser.sharedInstance.currentPath = FileParser.sharedInstance.documentsURL()
            
        }else{
            self.initialPath = FileParser.sharedInstance.currentPath
        }
        
        self.title = initialPath!.lastPathComponent
        // Set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        if flagMoveItem == false {
            
            editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(FileListViewController.showEditView))
            doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(FileListViewController.showEditView))
            self.navigationItem.rightBarButtonItem = editButton
            
        }else{
            
            doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(FileListViewController.performMoveItemAction))
            cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(FileListViewController.cancelMoveItemAction))
            self.navigationItem.setRightBarButtonItems([doneButton!,cancelButton!], animated: true)
            
            if self.initialPath == FileParser.sharedInstance.documentsURL() {
                self.title = "Move To"
            }
            
            normalView.hidden = true
            
        }
        
        
        
        if let initialPath = initialPath {
            files = parser.filesForDirectory(initialPath)
            indexFiles()
        }
        
        // Set search bar
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
        // Register for 3D touch
        self.registerFor3DTouch()
        
        if(!CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            //GADBannerView
            // self.setUpGoogleAds()
            shared = GADMasterViewController.singleton()
            shared.resetAdView(self, andDisplayView: bannerAdView)
        }
        
        
        selectAllInEditViewBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        zipBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        shareBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        openInBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        saveBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        newFolderBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        renameBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        moveBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        deleteBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        selectAllBtn.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.setContentOffset(CGPoint.zero, animated: true)
        if (CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            if(shared != nil) {
                shared = nil
            }
            bannerAdView.hidden = true
        }
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("FileListViewController Ad changed")
        for tempView in bannerAdView.subviews {
            tempView.removeFromSuperview()
        }
        self.bannerAdView.addSubview(bannerView)
    }
    
    
    
    func setFolderPathAndReloadTableView(path:NSURL) {
        
        files = parser.filesForDirectory(initialPath!)
        indexFiles()
        
    }
    
    func setFolderPathAndReloadTableView() {
        
        files = parser.filesForDirectory(initialPath!)
        indexFiles()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Scroll to hide search bar
        self.tableView.contentOffset = CGPointMake(0, searchController.searchBar.frame.size.height)
        
        // Make sure navigation bar is visible
        self.navigationController?.navigationBarHidden = false
        
        if let initialPath = initialPath {
            
            files = parser.filesForDirectory(initialPath)
            indexFiles()
            tableView.reloadData()
        }
    }
    
    func dismiss() {
        
        if filesForSharing.count > 0 {
            showActionSheet(0)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    
    func showEditView() {
        
        if flagShowEditView {
            flagShowEditView = false
            self.navigationItem.rightBarButtonItem = editButton
            self.tableView.reloadData()
            editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(FileListViewController.showEditView))
            UIView.animateWithDuration(Double(0.5), animations: {
                self.bottomHeightConstant.constant = 50
                self.view.layoutIfNeeded()
            })
            
        }else{
            
            flagShowEditView = true
            //            selectAllFiles(false)
            self.navigationItem.rightBarButtonItem = doneButton
            self.tableView.reloadData()
            UIView.animateWithDuration(Double(0.5), animations: {
                self.bottomHeightConstant.constant = 0
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    func cancelMoveItemAction() {
        self.delegate?.cancelMoveFile()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performMoveItemAction() {
        
        for i in 0..<moveItemPaths.count{
            
            if moveFileToPath(moveItemPaths[i].path!) == false {
                self.showAlertViewWithMessage("Error occured", message: "Unable to move all files, please create a new folder at that location and try again.")
                break
            }
        }
        self.delegate?.successMoveFile()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func moveFileToPath(folderPath:String) -> Bool {
        
        do{
            let fileName = (folderPath.componentsSeparatedByString("/").last)!
            let destinationPath = "\((self.initialPath?.path)!)/\(fileName)"
            
            print("folderpath = \(folderPath)")
            print("destinationPath = \(destinationPath)")
            
            if !kFileManager.fileExistsAtPath(folderPath) {
                return true
            }
            
            if folderPath == destinationPath {
                return true
            }
            try kFileManager.moveItemAtPath(folderPath, toPath: destinationPath)
            return true
            
        }catch let e as NSError{
            print(e)
        }
        
        return false
        
    }
    
    //MARK: Data
    
    func indexFiles() {
        let selector: Selector = Selector("displayName")
        sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
        if let sortedObjects = collation.sortedArrayFromArray(files, collationStringSelector: selector) as? [FBFile]{
            for object in sortedObjects {
                let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
        }
        
        if self.files.count == 0 {
            if lblNoContent == nil {
                lblNoContent = UILabel(frame: CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height))
                lblNoContent?.text = "No Content"
                lblNoContent?.backgroundColor = UIColor.whiteColor()
                lblNoContent?.textAlignment = .Center
                self.view.addSubview(lblNoContent!)
            }
            lblNoContent?.hidden = false
        }else{
            lblNoContent?.hidden = true
        }
    }
    
    func fileForIndexPath(indexPath: NSIndexPath) -> FBFile {
        var file: FBFile
        if searchController.active {
            file = filteredFiles[indexPath.row]
        }
        else {
            file = sections[indexPath.section][indexPath.row]
        }
        return file
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredFiles = files.filter({ (file: FBFile) -> Bool in
            return file.displayName.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    
    
}

extension FileListViewController{
    
    @IBAction func editViewButtonTapped(sender: AnyObject) {
        
        if sender as! NSObject == selectAllInEditViewBtn {
            print("SelectAllInEditViewBtn")
            let title = selectAllInEditViewBtn.titleForState(.Normal)
            
            if title == "Select All" {
                
                selectAllInEditViewBtn.setTitle("Deselect All", forState: .Normal)
                selectAllFiles(true)
                
            }else{
                
                selectAllInEditViewBtn.setTitle("Select All", forState: .Normal)
                selectAllFiles(false)
            }
            
        }else if sender as! NSObject == newFolderBtn {
            print("newFolderBtn")
            showNewFolderNameAlert("", customMessage: nil)
            
        }else if sender as! NSObject == renameBtn {
            print("renameBtn")
            
            if filesForSharing.count == 1 {
                showRenameFolderAlert((filesForSharing.first?.displayName)!, customMessage: nil)
            }else{
                
                self.showAlertViewWithMessage("", message: "Please select the file you want to rename.")
            }
            
            
        }else if sender as! NSObject == moveBtn {
            print("moveBtn")
            
            if filesForSharing.count > 0 {
                var moveItemLocalUrlPaths = [NSURL]()
                for i in 0 ..< filesForSharing.count {
                    let file =  filesForSharing[i]
                    moveItemLocalUrlPaths.append(file.filePath)
                }
                filesForSharing.removeAll()
                FileParser.sharedInstance.currentPath = FileParser.sharedInstance.documentsURL()
                FileParser.sharedInstance.excludesFilepaths = moveItemLocalUrlPaths
                let fileListViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("FileListViewController") as! FileListViewController
                fileListViewController.delegate = self
                fileListViewController.flagMoveItem = true
                fileListViewController.moveItemPaths = moveItemLocalUrlPaths
                let navController = UINavigationController(rootViewController: fileListViewController)
                self.presentViewController(navController, animated: true, completion: nil)
                
            }else{
                
                self.showAlertViewWithMessage("", message: "Please select the file you want to move.")
            }
            
        }else if sender as! NSObject == deleteBtn {
            print("deleteBtn")
            deleteFiles()
        }else{
            print("else")
        }
    }
    
    
    @IBAction func normalViewButtonTapped(sender: AnyObject){
        
        if sender as! NSObject == selectAllBtn {
            
            print("selectAllBtn")
            let title = selectAllBtn.titleForState(.Normal)
            
            if title == "Select All" {
                
                selectAllBtn.setTitle("Deselect All", forState: .Normal)
                selectAllFiles(true)
                
            }else{
                
                selectAllBtn.setTitle("Select All", forState: .Normal)
                selectAllFiles(false)
            }
            
        }else if sender as! NSObject == zipBtn {
            
            print("zipBtn")
            
            if filesForSharing.count == 0 {
                self.showAlertViewWithMessage("", message: "Please select atleast one file that you would like to compress.")
            }else{
                //TODO
                showEnterZipNameAlert(false)
            }
            
        }else if sender as! NSObject == shareBtn {
            
            print("shareBtn")
            if filesForSharing.count == 0 {
                self.showAlertViewWithMessage("", message: "Please select atleast one file that you want to share.")
            }else{
                //TODO
                
                if filesForSharing.count == 1 {
                    
                    if filesForSharing.first?.type == .zip || filesForSharing.first?.type == .ZIP {
                        //Share Only
                        CommonFunctions.sharedInstance.shareMyFile((self.filesForSharing.first?.filePath.path)!, vc: self)
                    }else{
                        //Compress and Share
                        compressAndShareSingleFile()
                    }
                    
                }else{
                    
                    compressAndShareMultipleFiles()
                    
                }
            }
            
        }else if sender as! NSObject == openInBtn {
            
            print("openInBtn")
            
            
            /*NSURL *url = [NSURL fileURLWithPath:filePath];
             UIDocumentInteractionController *popup = [UIDocumentInteractionController interactionControllerWithURL:url];
             [popup setDelegate:self];
             [popup presentPreviewAnimated:YES];*/
            
            if filesForSharing.count == 0 {
                
                self.showAlertViewWithMessage("", message: "Please select atleast one file that you would like to open in another app.")
                
            }else if filesForSharing.count > 1 {
                
                self.showAlertViewWithMessage("", message: "Please select only one file that you would like to open in another app.")
                
            }else{
                
                let popup = UIDocumentInteractionController(URL: (filesForSharing.first?.filePath)!)
                popup.delegate = self
                
                
                
                //                CGRect rectForAppearing = [sender.superview convertRect:sender.frame toView:self.view];
                //                [interactionController presentOptionsMenuFromRect:rect inView:self.view animated:YES];
                
                switch UIDevice.currentDevice().userInterfaceIdiom {
                    
                case .Phone:
                    
                    popup.presentOpenInMenuFromRect(openInBtn.frame, inView: self.view, animated: true)
                    break
                    
                case .Pad:
                    
                    popup.presentOptionsMenuFromRect(CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds),0,0), inView: self.view, animated: true)
                    
                    break
                case .Unspecified:
                    break
                default:
                    print("default")
                }
            }
            
        }else if sender as! NSObject == saveBtn {
            
            print("saveBtn")
            
            if filesForSharing.count == 0 {
                
                self.showAlertViewWithMessage("", message: "Please select atleast one photo/video file that you would like to save to your album")
                
            }else if CommonFunctions.sharedInstance.containsImageOrVideoFile(filesForSharing) == false{
                
                self.showAlertViewWithMessage("", message: "Please select only one file that you would like to open in another app.")
                
            }else{
                
                
                for file in filesForSharing {
                    
                    print(file.type)
                    
                    if file.type == .JPEG || file.type  == .jpeg || file.type == .JPG || file.type  == .jpg || file.type == .PNG || file.type  == .png || file.type == .gif || file.type  == .GIF {
                        
                        imageOpenCounter += 1
                        
                        if imageOpenCounter == 1 {
                            SwiftSpinner.show("Please wait...", animated: true)
                        }
                        
                        let image = UIImage(contentsOfFile: (file.filePath.path)!)
                        
                        UIImageWriteToSavedPhotosAlbum(image!, self, #selector(FileListViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
                        
                    }else if file.type == .M4V || file.type  == .MOV || file.type == .mp4 || file.type  == .mov {
                        
                        imageOpenCounter += 1
                        
                        if imageOpenCounter == 1 {
                            SwiftSpinner.show("Please wait...", animated: true)
                        }
                        
                        UISaveVideoAtPathToSavedPhotosAlbum((file.filePath.path)!, self, #selector(FileListViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
            }
            
        }
        
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        
        imageCloseCounter += 1
        
        guard error == nil else {
            //Error saving image
            if imageOpenCounter == imageCloseCounter {
                SwiftSpinner.hide()
                self.showAlertViewWithMessage("", message: "We are unable to save your photos/videos to your album.")
                imageOpenCounter = 0
                imageCloseCounter = 0
            }
            return
        }
        
        
        
        if imageOpenCounter == imageCloseCounter {
            SwiftSpinner.hide()
            self.showAlertViewWithMessage("", message: "Your photos/videos have been saved to your album.")
            imageOpenCounter = 0
            imageCloseCounter = 0
        }
        
        //Image saved successfully
    }
    
    func video(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo info: UnsafeMutablePointer<Void>) {
        // your completion code handled here
        
        imageCloseCounter += 1
        
        guard error == nil else {
            //Error saving image
            if imageOpenCounter == imageCloseCounter {
                SwiftSpinner.hide()
                self.showAlertViewWithMessage("", message: "We are unable to save your photos/videos to your album.")
                imageOpenCounter = 0
                imageCloseCounter = 0
            }
            return
        }
        
        
        
        if imageOpenCounter == imageCloseCounter {
            SwiftSpinner.hide()
            self.showAlertViewWithMessage("", message: "Your photos/videos have been saved to your album.")
            imageOpenCounter = 0
            imageCloseCounter = 0
        }
        
        //Image saved successfully
    }
    
    
    func compressAndShareSingleFile(){
        
        let msg = "You've selected a file or folder. The file/folder will be compressed first before it can be shared. Do you want to continue?"
        
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
        })
        
        let cancelAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
            self.showEnterZipNameAlert(true)
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func compressAndShareMultipleFiles(){
        
        let msg = "You've selected multiple files or folders or both. The files/folders will be compressed first before they can be shared. Do you want to continue?"
        
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
        })
        
        let cancelAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
            CommonFunctions.sharedInstance.shareAllMyFile( self , files: self.filesForSharing)
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
}

extension FileListViewController : MoveFileDelegate{
    
    func cancelMoveFile() {
        FileParser.sharedInstance.currentPath = (self.initialPath)!
        FileParser.sharedInstance.excludesFilepaths = nil
    }
    
    func successMoveFile() {
        
        FileParser.sharedInstance.currentPath = (self.initialPath)!
        FileParser.sharedInstance.excludesFilepaths = nil
        self.files = self.parser.filesForDirectory(self.initialPath!)
        self.indexFiles()
        self.tableView.reloadData()
    }
    
    
}

extension FileListViewController : UIDocumentInteractionControllerDelegate{
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    
}

