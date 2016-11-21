//
//  UIView+Additions.swift
//
//  Created by Pawan Joshi on 18/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
//import SwiftSpinner

// MARK: - UIView Extension
extension UIView {
    
    // - MARK: - Loading Progress View
    func showLoader(mainTitle title:String!, subTitle subtitle:String?) {
        
//        let hud = MBProgressHUD.showHUDAddedTo(self, animated: true)
//        hud.labelText = title
//        hud.detailsLabelText = subtitle
//        hud.square = true
//        hud.mode = .Indeterminate
        //hud.color = Colors.themeColor()
        
       // SwiftSpinner.showWithDelay(2.0, title: title)
        SwiftSpinner.show(title)

    }
    
    func hideLoader() {
          SwiftSpinner.hide()
        //MBProgressHUD.hideHUDForView(self, animated: true)
    }
}
