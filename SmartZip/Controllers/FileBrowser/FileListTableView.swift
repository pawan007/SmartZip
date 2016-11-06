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
import SwiftSpinner

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
        cell.selectionStyle = .None
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
        
        if flagShowEditView {
            //            let cell = tableView.dequeueReusableCellWithIdentifier("FileBrowserCell", forIndexPath: indexPath) as! FileBrowserCell
            //            cell.btnCheck.sendActionsForControlEvents(.TouchUpInside)
            return
        }
        
        if selectedFile.isDirectory {
            
            //            let fileListViewController = FileListViewController(initialPath: selectedFile.filePath)
            //            fileListViewController.didSelectFile = didSelectFile
            //            self.navigationController?.pushViewController(fileListViewController, animated: true)
            FileParser.sharedInstance.currentPath = selectedFile.filePath
            let fileListViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("FileListViewController") as! FileListViewController
            
            if flagMoveItem {
                fileListViewController.delegate = self
                fileListViewController.flagMoveItem = true
                fileListViewController.moveItemPaths = moveItemPaths
            }
            
            self.navigationController?.pushViewController(fileListViewController, animated: true)
            
            
        }else if selectedFile.fileExtension == "zip" {
            
            //            self.unzipFile(selectedFile)
            
            
            
            let unzipClass = UnZipExternal()
            
            
            
            unzipClass.unzipPathInner(selectedFile.filePath.path!)
            
            
            /*guard let unzipPath = getUnzipPath(selectedFile.filePath.path!) else {
             return
             }
             
             if !NSFileManager.defaultManager().fileExistsAtPath(unzipPath) {
             
             unzipClass.unzipPathInner(selectedFile.filePath.path!,unzipPath: unzipPath)
             
             }else{
             
             let incCount = getFileCopiesCount(unzipPath)
             let newPath = "\(unzipPath)-\(incCount)"
             unzipClass.unzipPathInner(selectedFile.filePath.path!,unzipPath: newPath)
             }*/
            
            self.files = self.parser.filesForDirectory(self.initialPath!)
            self.indexFiles()
            self.tableView.reloadData()
            
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
        
        /*if filesForSharing.count == 1 && filesForSharing.last?.type == FBFileType.zip {
         flagShowShareOptionOnly = true
         }else{
         flagShowShareOptionOnly = false
         }
         
         if filesForSharing.count == 1 && self.navigationItem.rightBarButtonItem?.title != "More"{
         
         let more = UIBarButtonItem(title: "More", style: .Done, target: self, action: #selector(FileListViewController.dismiss))
         self.navigationItem.rightBarButtonItem = more
         
         }else if filesForSharing.count == 0 {
         
         self.navigationItem.rightBarButtonItem = nil
         
         }*/
        
        
    }
    
    func showActionSheet(index:Int) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "More", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
            
        }
        actionSheetController.addAction(cancelAction)
        
        
        if flagShowShareOptionOnly {
            
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Share", style: .Default) { action -> Void in
                //Code for launching the camera goes here
                print("Apply Share code")
                CommonFunctions.sharedInstance.shareMyFile((self.filesForSharing.first?.filePath.path)!, vc: self)
            }
            actionSheetController.addAction(takePictureAction)
            
        }else{
            
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Zip and Share", style: .Default) { action -> Void in
                //Code for launching the camera goes here
                print("Apply Zip and Share code")
                self.showEnterZipNameAlert(false)
                
            }
            actionSheetController.addAction(takePictureAction)
            
        }
        
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            //Code for picking from camera roll goes here
            print("Delete File")
            self.deleteFiles()
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
    
    func deleteFiles() {
        
        if filesForSharing.count == 0 {
            
            self.showAlertViewWithMessage("", message: "Please select atleast one file that you would like to delete.")
            return
        }
        
        if self.filesForSharing.count > 0{
            for item in self.filesForSharing {
                if let index = self.files.indexOf(item){
                    self.files.removeAtIndex(index)
                    do{  try NSFileManager.defaultManager().removeItemAtPath(item.filePath.path!)
                    }catch let error{
                        print(error)
                    }
                }
            }
        }
        
        self.filesForSharing.removeAll()
        self.files = self.parser.filesForDirectory(self.initialPath!)
        self.indexFiles()
        self.tableView.reloadData()
    }
    
    
    func selectAllFiles(onOffValue:Bool) {
        
        filesForSharing.removeAll()
        let sectionCount = tableView.numberOfSections
        for i in 0 ..< sectionCount {
            let rowsCount = tableView.numberOfRowsInSection(i)
            for j in 0 ..< rowsCount {
                let indexPath = NSIndexPath(forRow: j, inSection: i)
                let selectedFile = fileForIndexPath(indexPath)
                selectedFile.isChecked = onOffValue
                
                if onOffValue {
                    filesForSharing.append(selectedFile)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func createNewFolder(folderPath:String) -> Bool {
        
        if(!kFileManager.fileExistsAtPath(folderPath)){
            
            do{
                try kFileManager.createDirectoryAtPath(folderPath, withIntermediateDirectories: false, attributes: nil)
                return true
            }catch let e as NSError{
                print(e)
            }
            
        }else{
            
            self.showAlertViewWithMessage("", message: "Foldername already exists, please provide another name.")
            
        }
        
        return false
        
    }
    
    
    func moveFileAtPath(folderPath:String) -> Bool {
        
        if(!kFileManager.fileExistsAtPath(folderPath)){
            
            do{
                
                if filesForSharing.first!.isDirectory {
                    
                    try kFileManager.moveItemAtPath((filesForSharing.first?.filePath.path)!, toPath: folderPath)
                    return true
                    
                }else{
                    
                    let fileExtension = (filesForSharing.first!.fileExtension)!
                    try kFileManager.moveItemAtPath((filesForSharing.first?.filePath.path)!, toPath: "\(folderPath).\(fileExtension)")
                    return true
                    
                }
                
            }catch let e as NSError{
                print(e)
            }
            
            
            
        }else{
            
            self.showAlertViewWithMessage("", message: "Foldername already exists, please provide another name.")
            
        }
        
        return false
        
    }
    
    func showNewFolderNameAlert(name:String, customMessage:String?){
        
        var msgText = ""
        if customMessage != nil {
            msgText = customMessage!
        }else{
            msgText = "Please enter new folder name"
            
        }
        
        let alertController = UIAlertController(title: "", message: msgText, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            let name = CommonFunctions.sharedInstance.trim(firstTextField.text!)
            
            if(name.length == 0){
                self.showNewFolderNameAlert(name, customMessage:"Please enter folder name")
                return
            }
            
            if(CommonFunctions.sharedInstance.validateName(name) == false){
                self.showNewFolderNameAlert(name, customMessage:"Special characters are not allowed")
                return
            }
            
            
            let path = "\((self.initialPath?.path)!)/\(name)"
            if(kFileManager.fileExistsAtPath(path)){
                self.showNewFolderNameAlert(name, customMessage:"Folder exists, please provide new name")
            }else{
                
                if self.createNewFolder(path){
                    self.files = self.parser.filesForDirectory(self.initialPath!)
                    self.indexFiles()
                    self.tableView.reloadData()
                }else{
                    self.showAlertViewWithMessage("", message: "Error occured")
                    
                }
                
            }
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.text = name
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    func showRenameFolderAlert(name:String, customMessage:String?){
        
        var msgText = ""
        if customMessage != nil {
            msgText = customMessage!
        }else{
            msgText = "Please enter new name"
            
        }
        
        let alertController = UIAlertController(title: "", message: msgText, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            let name = CommonFunctions.sharedInstance.trim(firstTextField.text!)
            
            if(name.length == 0){
                self.showRenameFolderAlert(name, customMessage:"Please enter folder name")
                return
            }
            
            if(CommonFunctions.sharedInstance.validateName(name) == false){
                self.showRenameFolderAlert(name, customMessage:"Special characters are not allowed")
                return
            }
            
            
            let path = "\((self.initialPath?.path)!)/\(name)"
            if(kFileManager.fileExistsAtPath(path)){
                self.showRenameFolderAlert(name, customMessage:"Folder exists, please provide new name")
            }else{
                
                if self.moveFileAtPath(path){
                    self.files = self.parser.filesForDirectory(self.initialPath!)
                    self.indexFiles()
                    self.tableView.reloadData()
                    self.filesForSharing.removeAll()
                }else{
                    self.showRenameFolderAlert("", customMessage: "There is some problem with this name, please try with another name.")
                    
                }
                
            }
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            
            if name.containsString("."){
                
                let  newName = name.componentsSeparatedByString(".").first
                textField.text = newName
            }else{
                textField.text = name
            }
            
            
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
            
            let incCount = getFileCopiesCount(unzipPath) + 1
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
    
    
    func showEnterZipNameAlert(canShare:Bool){
        
        let alertController = UIAlertController(title: "", message: "Please enter zip name", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if(firstTextField.text?.length == 0){
                
                self.showAlert("Please enter folder name", canShare: canShare)
                return
            }
            
            let newName = CommonFunctions.sharedInstance.trim((firstTextField.text)!)
            
            if(CommonFunctions.sharedInstance.validateName(newName) == false){
                
                self.showAlert("Special characters are not allowed", canShare: canShare)
                return
            }
            
            let zipFileName = "\((self.initialPath?.path)!)/\(newName).zip"
            let fileName = "\((self.initialPath?.path)!)/\(newName)"
            
            if(kFileManager.fileExistsAtPath(zipFileName) || kFileManager.fileExistsAtPath(fileName)){
                
                self.showAlert("Folder or file already exists, please provide new name", canShare: canShare)
                
            }else{
                
                
                var arrayPaths = [String]()
                for item in self.filesForSharing {
                    arrayPaths.append(item.filePath.path!)
                }
                
                if !CommonFunctions.sharedInstance.canCreateZip2(arrayPaths) {
                    
                    CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "You do not have enough space to create zip file", vc: self)
                    return
                }
                
                SwiftSpinner.show("Please Wait")
                
                let result = CommonFunctions.sharedInstance.zipAllMyFiles(zipFileName, vc: self, files: self.filesForSharing ,canShare: canShare)
                
                if(result){
                    
                    self.filesForSharing.removeAll()
                    self.files = self.parser.filesForDirectory(self.initialPath!)
                    self.indexFiles()
                    self.tableView.reloadData()
                }
                SwiftSpinner.hide()
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Please enter zip file name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(name:String, canShare:Bool){
        
        let alertController = UIAlertController(title: "", message: name, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            self.showEnterZipNameAlert(canShare)
            
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}