//
//  FlieListTableView.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit
import SSZipArchive

extension FileListViewController: UITableViewDataSource, UITableViewDelegate, FileBrowserCellDelegate {
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active {
            return 1
        }
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredFiles.count
        }
        return sections[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*let cellIdentifier = "FileCell"
         var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
         if let reuseCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
         cell = reuseCell
         }*/
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FileBrowserCell", forIndexPath: indexPath) as! FileBrowserCell
        
        cell.delgate = self
        cell.selectionStyle = .Blue
        let selectedFile = fileForIndexPath(indexPath)
        //        cell.textLabel?.text = selectedFile.displayName
        //        cell.imageView?.image = selectedFile.type.image()
        cell.fbImage.image = selectedFile.type.image()
        cell.fbName.text = selectedFile.displayName
        cell.checkedStatus = selectedFile.isChecked
        
        if selectedFile.isChecked {
            cell.btnCheck.setImage(UIImage(named: "icon_checked"), forState: .Normal)
        }else{
            cell.btnCheck.setImage(UIImage(named: "icon_unchecked"), forState: .Normal)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedFile = fileForIndexPath(indexPath)
        searchController.active = false
        if selectedFile.isDirectory {
            
            //            let fileListViewController = FileListViewController(initialPath: selectedFile.filePath)
            //            fileListViewController.didSelectFile = didSelectFile
            //            self.navigationController?.pushViewController(fileListViewController, animated: true)
            FileParser.sharedInstance.currentPath = selectedFile.filePath
            let fileListViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("FileListViewController") as! FileListViewController
            self.navigationController?.pushViewController(fileListViewController, animated: true)
            
        }else if selectedFile.fileExtension == "zip" {
            
            self.unzipFile(selectedFile)
            
            
        }
        else {
            if let didSelectFile = didSelectFile {
                self.dismiss()
                didSelectFile(selectedFile)
            }
            else {
                let filePreview = previewManager.previewViewControllerForFile(selectedFile, fromNavigation: true)
                self.navigationController?.pushViewController(filePreview, animated: true)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.active {
            return nil
        }
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if searchController.active {
            return nil
        }
        return collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if searchController.active {
            return 0
        }
        return collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    func checkUnCheckBtn(cell: FileBrowserCell, value: Bool) {
        
        let indexPath = tableView.indexPathForCell(cell)
        let selectedFile = fileForIndexPath(indexPath!)
        
        if value {
            //            print(selectedFile.filePath)
            selectedFile.isChecked = true
            filesForSharing.append(selectedFile)
        }else{
            selectedFile.isChecked = false
            let index = filesForSharing.indexOf(selectedFile)
            filesForSharing.removeAtIndex(index!)
        }
        
        print(filesForSharing)
        
        if filesForSharing.count == 1 && self.navigationItem.rightBarButtonItem?.title != "More"{
            
            let more = UIBarButtonItem(title: "More", style: .Done, target: self, action: #selector(FileListViewController.dismiss))
            self.navigationItem.rightBarButtonItem = more
            
        }else if filesForSharing.count == 0 {
            
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(FileListViewController.dismiss))
            self.navigationItem.rightBarButtonItem = dismissButton
            
        }
        
        
    }
    
    func showActionSheet(index:Int) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "More", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            
        }
        actionSheetController.addAction(cancelAction)
        
        
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Share", style: .Default) { action -> Void in
            //Code for launching the camera goes here
            print("Apply Zip and Share code")
            
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
            print("Delete File")
            
            if self.filesForSharing.count > 0{
                
                for item in self.filesForSharing {
                    if let index = self.files.indexOf(item){
                        
                        self.files.removeAtIndex(index)
                        //                       let file  = item
                        do{  try NSFileManager.defaultManager().removeItemAtPath(item.filePath.path!)
                            
                        }catch let error{
                            
                            print(error)
                        }
                    }
                    
                    
                    
                }
            }
            self.files = self.parser.filesForDirectory(self.initialPath!)
            self.indexFiles()
            self.tableView.reloadData()
        }
        actionSheetController.addAction(choosePictureAction)
        
        if searchController.active {
            //Create and add first option action
            let cancelSearch: UIAlertAction = UIAlertAction(title: "Cancel Search", style: .Default) { action -> Void in
                //Code for launching the camera goes here
                print("Cancel Search")
            }
            actionSheetController.addAction(cancelSearch)
        }
        
        if let popoverPresentationController = actionSheetController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            var rect=self.view.frame
            rect.origin.y = rect.height
            popoverPresentationController.sourceRect = rect
        }
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func unzipFile(zipFie:FBFile) {
        
        guard let unzipPath = getUnzipPath(zipFie.filePath.path!) else {
            return
        }
        
        if !NSFileManager.defaultManager().fileExistsAtPath(unzipPath) {
            
            let success = SSZipArchive.unzipFileAtPath(zipFie.filePath.path!, toDestination: unzipPath)
            if !success {
                return
            }
            
        }else{
            
            var incCount = getFileCopiesCount(unzipPath) + 1
            let newPath = "\(unzipPath)(\(incCount))"
            let success = SSZipArchive.unzipFileAtPath(zipFie.filePath.path!, toDestination: newPath)
            if !success {
                return
            }
        }
        
        self.files = self.parser.filesForDirectory(self.initialPath!)
        self.indexFiles()
        self.tableView.reloadData()
        
    }
    
    func getFileCopiesCount(path:String) -> Int {
        
        var folderHierarchy = path.componentsSeparatedByString("/")
        folderHierarchy.removeLast()
        let pathParent = folderHierarchy.joinWithSeparator("/")
        var count = 0
        if let enumerator = NSFileManager.defaultManager().enumeratorAtPath(pathParent) {
            while let fileName = enumerator.nextObject() as? String {
                
                let filePath = "\(pathParent)/\(fileName)"
                if filePath.containsString(path) && path.componentsSeparatedByString("/").count == filePath.componentsSeparatedByString("/").count{
                    print(filePath)
                    count = count + 1
                }
            }
        }
        return count
    }
    
    
    func getUnzipPath(zipPath:String) -> String? {
        
        let array = zipPath.componentsSeparatedByString(".")
        return array.first
    }
    
    
    
    
    
}