//
//  DesignableTextView.swift
//  SmartZip
//
//  Created by Pawan Kumar on 02/06/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit

@IBDesignable

class DesignableTextView: UITextView {
    @IBInspectable var roundBottom: Bool = false
    @IBInspectable var cornerRadius: CGFloat = 22
    
    func textRectForBounds(_ bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 22, dy: 0)
    }
    
    func editingRectForBounds(_ bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 22, dy: 0)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let cornerRadii: CGSize = CGSize(width: cornerRadius, height: cornerRadius)
        
        let topBounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height / 2)
        let bottomBounds = CGRect(x: 0, y: rect.height / 2, width: rect.width, height: rect.height / 2)
        
        let topPathRoundedCorners: UIRectCorner = roundBottom ? [] : [.topLeft, .topRight]
        let bottomPathRoundedCorners: UIRectCorner = roundBottom ? [.bottomLeft, .bottomRight] : []
        
        let topPath = UIBezierPath(roundedRect: topBounds, byRoundingCorners: topPathRoundedCorners, cornerRadii: cornerRadii)
        let bottomPath = UIBezierPath(roundedRect: bottomBounds, byRoundingCorners: bottomPathRoundedCorners, cornerRadii: cornerRadii)
        
        topPath.append(bottomPath)
        
        let layer = CAShapeLayer()
        
        layer.path = topPath.cgPath
        layer.bounds = rect
        layer.position = self.center
        layer.fillColor = UIColor.white.cgColor
        layer.lineWidth = 0
        layer.strokeColor = UIColor.clear.cgColor
        
        self.layer.insertSublayer(layer, at: 0)
        
    }
}
