//
//  FileBrowserCell.swift
//  TestFileBrowser
//
//  Created by Pawan Dhawan on 27/07/16.
//  Copyright © 2016 Pawan Dhawan. All rights reserved.
//

import UIKit

protocol FileBrowserCellDelegate {
    func checkUnCheckBtn(_ cell:FileBrowserCell, value:Bool)
}

class FileBrowserCell: UITableViewCell {
    
    var delgate:FileBrowserCellDelegate?
    
    var checkedStatus = false
    
    @IBOutlet weak var fbImage: UIImageView!
    
    @IBOutlet weak var fbName: UILabel!
    
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBAction func btnCheckTapped(_ sender: AnyObject) {
        
        if checkedStatus {
            
            checkedStatus = false
            btnCheck.setImage(UIImage(named: "icon_unchecked"), for: UIControlState())
            delgate?.checkUnCheckBtn(self, value:false)
            
        }else{
            
            checkedStatus = true
            btnCheck.setImage(UIImage(named: "icon_checked"), for: UIControlState())
            delgate?.checkUnCheckBtn(self, value:true)
        }
        
    }
    
}
