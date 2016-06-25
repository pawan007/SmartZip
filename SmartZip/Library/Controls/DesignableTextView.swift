//
//  DesignableTextView.swift
//  HolidayHappenings
//
//  Created by Pawan Kumar on 02/06/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit

@IBDesignable

class DesignableTextView: UITextView {
    @IBInspectable var roundBottom: Bool = false
    @IBInspectable var cornerRadius: CGFloat = 22
    
    func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 22, 0)
    }
    
    func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 22, 0)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let cornerRadii: CGSize = CGSize(width: cornerRadius, height: cornerRadius)
        
        let topBounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height / 2)
        let bottomBounds = CGRect(x: 0, y: rect.height / 2, width: rect.width, height: rect.height / 2)
        
        let topPathRoundedCorners: UIRectCorner = roundBottom ? [] : [.TopLeft, .TopRight]
        let bottomPathRoundedCorners: UIRectCorner = roundBottom ? [.BottomLeft, .BottomRight] : []
        
        let topPath = UIBezierPath(roundedRect: topBounds, byRoundingCorners: topPathRoundedCorners, cornerRadii: cornerRadii)
        let bottomPath = UIBezierPath(roundedRect: bottomBounds, byRoundingCorners: bottomPathRoundedCorners, cornerRadii: cornerRadii)
        
        topPath.appendPath(bottomPath)
        
        let layer = CAShapeLayer()
        
        layer.path = topPath.CGPath
        layer.bounds = rect
        layer.position = self.center
        layer.fillColor = UIColor.whiteColor().CGColor
        layer.lineWidth = 0
        layer.strokeColor = UIColor.clearColor().CGColor
        
        self.layer.insertSublayer(layer, atIndex: 0)
        
    }
}
