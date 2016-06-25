//
//  NotificationViewController.swift
//  SmartZip
//
//  Created by Pawan Kumar on 02/06/16.
//  Copyright © 2016 Modi. All rights reserved.
//

 import Foundation
import UIKit
import StoreKit

class NotificationViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let CellIdentifierUnRead: String = "CellUnRead"
    let CellIdentifierRead: String = "CellRead"

    var location = NSMutableArray()
    var favorite : Int = -1
    
    override internal func viewDidLoad() {
        
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 50.0;
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsMultipleSelection = false
        location.addObject("Thank you for purchasing the app.")
        location.addObject("Photography event near your location.")
        location.addObject("Cooking event near your location.")
        location.addObject("Swimming event near your location.")
        self.tableView.reloadData()
    }
    
    override internal func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.count
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell! = nil
        if indexPath.row > 1 {
            cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifierRead, forIndexPath: indexPath)
        }
        else {
            cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifierUnRead, forIndexPath: indexPath)
        }
        
        cell.selectionStyle = .Gray
        let name: UILabel! = cell.viewWithTag(1000) as! UILabel
        name.text = location[indexPath.row] as? String
        return cell
    }
    
    // MARK:- IBActions
    @IBAction override func menuButtonAction(sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                
            }
        }
    }
    

}