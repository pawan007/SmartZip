//
//  HistoryVC.swift
//  SmartZip
//
//  Created by Pawan Dhawan on 21/07/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import UIKit

class HistoryVC: UIViewController {
    
    
    
    
    // don't forget to hook this up from the storyboard
    @IBOutlet var tableView: UITableView!
    
    // Data model: These strings will be the data for the table view cells
    var fileNames: [String] = []
    var filePaths: [String] = []
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        //        self.navigationController?.navigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        getZipFileList()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileNames.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        cell.textLabel?.text = fileNames[indexPath.row]
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
        showActionSheet(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool{
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath){
        
        if editingStyle == .delete {
            
            let path = filePaths[indexPath.row]
            print(path)
            try! kFileManager.removeItem(atPath: filePaths[indexPath.row])
            filePaths.remove(at: indexPath.row)
            fileNames.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
    }
    
    @IBAction   func menuButtonAction(_ sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
    
    func getZipFileList() -> Void {
        
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        
        if let enumerator = kFileManager.enumerator(atPath: directoryPath!) {
            while let fileName = enumerator.nextObject() as? String {
                
                if fileName.contains(".zip") {
                    
                    fileNames.append(fileName)
                    filePaths.append("\(directoryPath!)/\(fileName)")
                }
                
            }
        }
        
        tableView.reloadData()
        
    }
    
    
    
    func showActionSheet(_ index:Int) {
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: kAlertTitle, message: "", preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
            CommonFunctions.sharedInstance.getFreeDiscSpase()
            
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Share", style: .default) { action -> Void in
            //Code for launching the camera goes here
            let path = self.filePaths[index]
            print(path)
            CommonFunctions.sharedInstance.shareMyFile(path, vc: self)
            
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default) { action -> Void in
            //Code for picking from camera roll goes here
            let path = self.filePaths[index]
            print(path)
            try! kFileManager.removeItem(atPath: self.filePaths[index])
            self.filePaths.remove(at: index)
            self.fileNames.remove(at: index)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(choosePictureAction)
        
        if let popoverPresentationController = actionSheetController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            var rect=self.view.frame
            rect.origin.y = rect.height
            popoverPresentationController.sourceRect = rect
        }
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
