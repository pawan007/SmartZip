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
        location.add("Thank you for purchasing the app.")
        location.add("Photography event near your location.")
        location.add("Cooking event near your location.")
        location.add("Swimming event near your location.")
        self.tableView.reloadData()
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return location.count
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell! = nil
        if indexPath.row > 1 {
            cell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifierRead, for: indexPath)
        }
        else {
            cell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifierUnRead, for: indexPath)
        }
        
        cell.selectionStyle = .gray
        let name: UILabel! = cell.viewWithTag(1000) as! UILabel
        name.text = location[indexPath.row] as? String
        return cell
    }
    
    // MARK:- IBActions
    @IBAction override func menuButtonAction(_ sender: AnyObject) {
        if let container = SideMenuManager.sharedManager().container {
            container.toggle(.left, animated: true) { (val) -> Void in
                
            }
        }
    }
    

}
