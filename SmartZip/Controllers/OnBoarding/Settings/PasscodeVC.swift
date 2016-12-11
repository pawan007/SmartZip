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
    
    fileprivate var topTableIDs = ["PasscodeCell","ChangePasscodeCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(_ sender: AnyObject) {
        self.dismiss(animated: true) {
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let identifier  = topTableIDs[indexPath.row]
        
        switch identifier {
        case "Home" :
            break
        case "HelpCell" : break
        //TODO
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  topTableIDs.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: topTableIDs[indexPath.row])
        return cell!
    }
    
}
