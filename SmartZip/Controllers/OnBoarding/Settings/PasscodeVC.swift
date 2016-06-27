//
//  PasscodeVC.swift
//  SmartZip
//
//  Created by Pawan Kumar on 26/06/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import UIKit

class PasscodeVC: UIViewController {
    
    @IBOutlet weak var topTableView: UITableView!
    
    private var topTableIDs = ["PasscodeCell","ChangePasscodeCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.topTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            
        }
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier  = topTableIDs[indexPath.row]
        
        switch identifier {
        case "Home" :
            break
        case "HelpCell" : break
        //TODO
        default: break
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  topTableIDs.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(topTableIDs[indexPath.row])
        return cell!
    }
    
}
