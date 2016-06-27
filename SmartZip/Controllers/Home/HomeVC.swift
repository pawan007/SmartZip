//
//  HomeVC.swift
//  SmartZip
//
//  Created by Pawan Kumar on 26/06/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import UIKit
import FileBrowser

class HomeVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath\(indexPath.row)")
    }
    @IBAction   func menuButtonAction(sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
    
    func handleLocalFile() {
        let fileBrowser = FileBrowser()
        self.presentViewController(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print(file.displayName)
        }
    }
    
    
    
}
