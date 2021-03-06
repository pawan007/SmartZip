//
//  FileListViewController.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit


class FileListViewController: UIViewController {
    
    
    @IBOutlet weak var bannerAdView: UIView!
    var shared:GADMasterViewController!
    var lblNoContent:UILabel?
    
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
    
    //MARK: Lifecycle
    
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
        
        /*// Add dismiss button
         let dismissButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(FileListViewController.dismiss))
         self.navigationItem.rightBarButtonItem = dismissButton*/
        self.navigationItem.rightBarButtonItem = nil
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
        
        // Add dismiss button
        //        let dismissButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(FileListViewController.dismiss))
        //        self.navigationItem.rightBarButtonItem = dismissButton
        
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
    }
    
    func dismiss() {
        
        if filesForSharing.count > 0 {
            showActionSheet(0)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
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

