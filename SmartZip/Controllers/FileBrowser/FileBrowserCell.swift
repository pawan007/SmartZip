//
//  FileBrowserCell.swift
//  TestFileBrowser
//
//  Created by Pawan Dhawan on 27/07/16.
//  Copyright © 2016 Pawan Dhawan. All rights reserved.
//

import UIKit

protocol FileBrowserCellDelegate {
    func checkUnCheckBtn(cell:FileBrowserCell, value:Bool)
}

class FileBrowserCell: UITableViewCell {
    
    var delgate:FileBrowserCellDelegate?
    
    var checkedStatus = false
    
    @IBOutlet weak var fbImage: UIImageView!
    
    @IBOutlet weak var fbName: UILabel!
    
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var btnTop: UIButton!
    
    
    @IBAction func btnCheckTapped(sender: AnyObject) {
        
        if checkedStatus {
            
            checkedStatus = false
            btnCheck.setImage(UIImage(named: "icon_unchecked"), forState: .Normal)
            delgate?.checkUnCheckBtn(self, value:false)
            
        }else{
            
            checkedStatus = true
            btnCheck.setImage(UIImage(named: "icon_checked"), forState: .Normal)
            delgate?.checkUnCheckBtn(self, value:true)
        }
        
    }
    
    @IBAction func btnTopTapped(sender: AnyObject) {
        
        if checkedStatus {
            
            checkedStatus = false
            btnCheck.setImage(UIImage(named: "icon_unchecked"), forState: .Normal)
            delgate?.checkUnCheckBtn(self, value:false)
            
        }else{
            
            checkedStatus = true
            btnCheck.setImage(UIImage(named: "icon_checked"), forState: .Normal)
            delgate?.checkUnCheckBtn(self, value:true)
        }
        
    }
    
}
