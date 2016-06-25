//
//  UITextField+Additions.swift
//
//  Created by Geetika Gupta on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITextField Extension
extension UITextField {
    
    /**
     Override method of awake from nib to change font size as per aspect ratio.
     */
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        
        if let font = self.font {
            
            let screenRatio = (UIScreen.mainScreen().bounds.size.width / CGFloat(Constants.DEFAULT_SCREEN_RATIO))
            //let fontSize = font.pointSize * screenRatio
            
          //  self.font = UIFont(name: font.fontName, size: fontSize)!
        }
    }
    
    func isTextFieldEmpty() -> Bool {
        
        if let str = self.text /*self.textByTrimmingWhiteSpacesAndNewline()*/ {
            return (str.length == 0)
        }
        return true
    }
    
    func textByTrimmingWhiteSpacesAndNewline() -> String {
        
        self.trimWhiteSpacesAndNewline()
        
        guard let _ = self.text else {
            return ""
        }
        return self.text!
    }
    
    func trimWhiteSpacesAndNewline() {
        let whitespaceAndNewline: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let trimmedString: String? = self.text?.stringByTrimmingCharactersInSet(whitespaceAndNewline)
        self.text = trimmedString
    }

    
    // MARK: Control Actions
    @IBAction func toggleSecureText() {
        self.secureTextEntry = !self.secureTextEntry
    }
}