//
//  FirstViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        
        super.addLeftMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeViewAction(sender: AnyObject) {
       // let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ReportDetailVC") as! ReportDetailVC
       // self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

