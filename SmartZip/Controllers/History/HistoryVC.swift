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
    var fileNames: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    var filePaths: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        // Register the table view cell class and its reuse id
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        //        self.navigationController?.navigationBarHidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        getZipFileList()
    }
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileNames.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        cell.textLabel?.text = fileNames[indexPath.row]
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You tapped cell number \(indexPath.row).")
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        
        if editingStyle == .Delete {
            
            try! NSFileManager.defaultManager().removeItemAtPath(filePaths[indexPath.row])
            tableView.reloadData()
        }
        
    }
    
    @IBAction   func menuButtonAction(sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
    
    func getZipFileList() -> Void {
        
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        
        if let enumerator = NSFileManager.defaultManager().enumeratorAtPath(directoryPath!) {
            while let fileName = enumerator.nextObject() as? String {
                
                if fileName.containsString(".zip") {
                    
                    fileNames.append(fileName)
                    filePaths.append("\(directoryPath)\(fileName)")
                }
                
            }
        }
        
        tableView.reloadData()
        
    }
    
}
