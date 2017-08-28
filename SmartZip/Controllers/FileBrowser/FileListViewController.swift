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
    let collation = UILocalizedIndexedCollation.current()
    
    /// Data
    var didSelectFile: ((FBFile) -> ())?
    var files = [FBFile]()
    var filesForSharing = [FBFile]()
    var initialPath: URL?
    let parser = FileParser.sharedInstance
    let previewManager = PreviewManager()
    var sections: [[FBFile]] = []
    
    // Search controller
    var filteredFiles = [FBFile]()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    var flagShowShareOptionOnly = false
    
    //MARK: Lifecycle
    
    convenience init (initialPath: URL) {
        
        //        self.init(nibName: "FileBrowser", bundle: NSBundle(forClass: FileListViewController.self))
        self.init()
        self.edgesForExtendedLayout = UIRectEdge()
        
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
        self.edgesForExtendedLayout = UIRectEdge()
        
        if  FileParser.sharedInstance.currentPath == nil{
            self.initialPath = FileParser.sharedInstance.documentsURL() as URL
            FileParser.sharedInstance.currentPath = FileParser.sharedInstance.documentsURL()
            
        }else{
            self.initialPath = FileParser.sharedInstance.currentPath as! URL
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
        
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
    
    
    
    func setFolderPathAndReloadTableView(_ path:URL) {
        
        files = parser.filesForDirectory(initialPath!)
        indexFiles()
        
    }
    
    func setFolderPathAndReloadTableView() {
        
        files = parser.filesForDirectory(initialPath!)
        indexFiles()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Scroll to hide search bar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
        
        // Make sure navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func dismiss() {
        
        if filesForSharing.count > 0 {
            showActionSheet(0)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    //MARK: Data
    
    func indexFiles() {
        let selector: Selector = #selector(getter: UIPrinter.displayName)
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        if let sortedObjects = collation.sortedArray(from: files, collationStringSelector: selector) as? [FBFile]{
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
        }
        
        if self.files.count == 0 {
            if lblNoContent == nil {
                lblNoContent = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
                lblNoContent?.text = "No Content"
                lblNoContent?.backgroundColor = UIColor.white
                lblNoContent?.textAlignment = .center
                self.view.addSubview(lblNoContent!)
            }
            lblNoContent?.isHidden = false
        }else{
            lblNoContent?.isHidden = true
        }
    }
    
    func fileForIndexPath(_ indexPath: IndexPath) -> FBFile {
        var file: FBFile
        if searchController.isActive {
            file = filteredFiles[indexPath.row]
        }
        else {
            file = sections[indexPath.section][indexPath.row]
        }
        return file
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFiles = files.filter({ (file: FBFile) -> Bool in
            return file.displayName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
}

