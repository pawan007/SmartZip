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
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive {
            return 1
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredFiles.count
        }
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*let cellIdentifier = "FileCell"
         var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
         if let reuseCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
         cell = reuseCell
         }*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileBrowserCell", for: indexPath) as! FileBrowserCell
        
        cell.delgate = self
        cell.selectionStyle = .blue
        let selectedFile = fileForIndexPath(indexPath)
        //        cell.textLabel?.text = selectedFile.displayName
        //        cell.imageView?.image = selectedFile.type.image()
        cell.fbImage.image = selectedFile.type.image()
        cell.fbName.text = selectedFile.displayName
        cell.checkedStatus = selectedFile.isChecked
        
        if selectedFile.isChecked {
            cell.btnCheck.setImage(UIImage(named: "icon_checked"), for: UIControlState())
        }else{
            cell.btnCheck.setImage(UIImage(named: "icon_unchecked"), for: UIControlState())
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = fileForIndexPath(indexPath)
        searchController.isActive = false
        if selectedFile.isDirectory {
            
            //            let fileListViewController = FileListViewController(initialPath: selectedFile.filePath)
            //            fileListViewController.didSelectFile = didSelectFile
            //            self.navigationController?.pushViewController(fileListViewController, animated: true)
            FileParser.sharedInstance.currentPath = selectedFile.filePath
            let fileListViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileListViewController") as! FileListViewController
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive {
            return nil
        }
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive {
            return nil
        }
        return collation.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchController.isActive {
            return 0
        }
        return collation.section(forSectionIndexTitle: index)
    }
    
    func checkUnCheckBtn(_ cell: FileBrowserCell, value: Bool) {
        
        let indexPath = tableView.indexPath(for: cell)
        let selectedFile = fileForIndexPath(indexPath!)
        
        if value {
            //            print(selectedFile.filePath)
            selectedFile.isChecked = true
            filesForSharing.append(selectedFile)
        }else{
            selectedFile.isChecked = false
            let index = filesForSharing.index(of: selectedFile)
            filesForSharing.remove(at: index!)
        }
        
        print(filesForSharing)
        
        
        if filesForSharing.count == 1 && filesForSharing.last?.type == FBFileType.zip {
            flagShowShareOptionOnly = true
        }else{
            flagShowShareOptionOnly = false
        }
        
        if filesForSharing.count == 1 && self.navigationItem.rightBarButtonItem?.title != "More"{
            
            let more = UIBarButtonItem(title: "More", style: .done, target: self, action: #selector(FileListViewController.dismiss))
            self.navigationItem.rightBarButtonItem = more
            
        }else if filesForSharing.count == 0 {
            
            self.navigationItem.rightBarButtonItem = nil
            
        }
        
        
    }
    
    func showActionSheet(_ index:Int) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "More", message: "", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            
        }
        actionSheetController.addAction(cancelAction)
        
        
        if flagShowShareOptionOnly {
            
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { action -> Void in
                //Code for launching the camera goes here
                print("Apply Share code")
                CommonFunctions.sharedInstance.shareMyFile((self.filesForSharing.first?.filePath.path)!, vc: self)
            }
            actionSheetController.addAction(takePictureAction)
            
        }else{
            
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Zip and Share", style: .default) { action -> Void in
                //Code for launching the camera goes here
                print("Apply Zip and Share code")
                self.showEnterZipNameAlert()
                
            }
            actionSheetController.addAction(takePictureAction)
            
        }
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { action -> Void in
            //Code for picking from camera roll goes here
            print("Delete File")
            
            if self.filesForSharing.count > 0{
                
                for item in self.filesForSharing {
                    if let index = self.files.index(of: item){
                        
                        self.files.remove(at: index)
                        //                       let file  = item
                        do{  try FileManager.default.removeItem(atPath: item.filePath.path!)
                            
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
        actionSheetController.addAction(choosePictureAction)
        
        if searchController.isActive {
            //Create and add first option action
            let cancelSearch: UIAlertAction = UIAlertAction(title: "Cancel Search", style: .default) { action -> Void in
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
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    
    func unzipFile(_ zipFie:FBFile) {
        
        guard let unzipPath = getUnzipPath(zipFie.filePath.path!) else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: unzipPath) {
            
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
    
    func getFileCopiesCount(_ path:String) -> Int {
        
        var folderHierarchy = path.components(separatedBy: "/")
        folderHierarchy.removeLast()
        let pathParent = folderHierarchy.joined(separator: "/")
        var count = 0
        if let enumerator = FileManager.default.enumerator(atPath: pathParent) {
            while let fileName = enumerator.nextObject() as? String {
                
                let filePath = "\(pathParent)/\(fileName)"
                if filePath.contains(path) && path.components(separatedBy: "/").count == filePath.components(separatedBy: "/").count{
                    print(filePath)
                    count = count + 1
                }
            }
        }
        return count
    }
    
    
    func getUnzipPath(_ zipPath:String) -> String? {
        
        let array = zipPath.components(separatedBy: ".")
        return array.first
    }
    
    
    func showEnterZipNameAlert(){
        
        let alertController = UIAlertController(title: "Wait", message: "Please enter zip name", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if(firstTextField.text?.length == 0){
                
                self.showAlert("Please enter folder name")
                return
            }
            
            if(firstTextField.text?.isValidName() == false){
                
                self.showAlert("Special characters are not allowed")
                return
            }
            
            
            let zipFileName = "\((self.initialPath?.path)!)/\(firstTextField.text!).zip"
            let fileName = "\((self.initialPath?.path)!)/\(firstTextField.text!)"
            
            if(kFileManager.fileExists(atPath: zipFileName) || kFileManager.fileExists(atPath: fileName)){
                
                self.showAlert("Folder or file already exists, please provide new name")
                
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
                
                let result = CommonFunctions.sharedInstance.zipAllMyFiles(zipFileName, vc: self, files: self.filesForSharing)
                
                if(result){
                    
                    self.filesForSharing.removeAll()
                    self.files = self.parser.filesForDirectory(self.initialPath!)
                    self.indexFiles()
                    self.tableView.reloadData()
                }
                SwiftSpinner.hide()
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Please enter zip file name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(_ name:String){
        
        let alertController = UIAlertController(title: "Wait", message: name, preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            self.showEnterZipNameAlert()
            
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
