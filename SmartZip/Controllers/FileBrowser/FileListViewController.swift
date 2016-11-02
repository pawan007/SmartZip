//
//  FileListViewController.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit


protocol MoveFileDelegate {
    func cancelMoveFile()
    func successMoveFile()
}

class FileListViewController: UIViewController {
    
    
    @IBOutlet weak var bannerAdView: UIView!
    var shared:GADMasterViewController!
    var lblNoContent:UILabel?
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var selectAllInEditViewBtn: UIButton!
    @IBOutlet weak var newFolderBtn: UIButton!
    @IBOutlet weak var renameBtn: UIButton!
    @IBOutlet weak var sortBtn: UIButton!
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
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentOffset = CGPointMake(0, searchController.searchBar.frame.size.height)
        
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
            editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(FileListViewController.showEditView))
            UIView.animateWithDuration(Double(0.5), animations: {
                self.bottomHeightConstant.constant = -50
                self.view.layoutIfNeeded()
            })
            
        }else{
            
            flagShowEditView = true
            selectAllFiles(false)
            self.navigationItem.rightBarButtonItem = doneButton
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
            
            
        }else if sender as! NSObject == sortBtn {
            print("sortBtn")
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
            
            
            
        }else if sender as! NSObject == zipBtn {
            
            
            
        }else if sender as! NSObject == shareBtn {
            
            
            
        }else if sender as! NSObject == openInBtn {
            
            
        }else if sender as! NSObject == saveBtn {
            
            
            
        }
    
    
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

