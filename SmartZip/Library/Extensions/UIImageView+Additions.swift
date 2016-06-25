//
//  UIImageView+Additions.swift
//
//  Created by Pawan Joshi on 01/04/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import UIKit
private let kFontResizingProportion = 0.42

// MARK: - UIImageView Extension
extension UIImageView {
    
    /**
     Sets image, created with initials of the string supplied
     - parameter string : string whose initials has to be created
     - returns : new UIImage created from string value supplied
     */
    func setImageWithString(string: String) {
        self.setImageWithString(string, color: nil, isCircular: true, textAttributes: nil)
    }

    /**
     Sets image, created with initials of the string supplied
     - parameter txtString      : string whose initials has to be created
     - parameter color          : background color of image
     - parameter isCircular     : round/square image background
     - parameter textAttributes : attributes for string inside image 
     - returns : new UIImage created from string value supplied
     */
    func setImageWithString(txtString: String, color: UIColor?, isCircular: Bool, textAttributes: [String : AnyObject]?) {
        
        var textAttr:[String : AnyObject]?
        if textAttributes == nil {
            textAttr = [NSFontAttributeName:self.fontForFontName(nil)!,NSForegroundColorAttributeName:UIColor.whiteColor()]
        } else {
            textAttr = textAttributes
        }
        
        let string : NSString = NSString(string: txtString)
        let displayString:NSMutableString = NSMutableString(string: "")
        
        let words : NSMutableArray = NSMutableArray(array: string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        
        if words.count > 0 {
            let firstWord : NSString = words.firstObject as! NSString
            if firstWord.length > 0 {
                let firstLetterRange:NSRange = firstWord.rangeOfComposedCharacterSequencesForRange(NSMakeRange(0, 1))
                
                displayString.appendString(String(firstWord.substringWithRange(firstLetterRange)))
            }
            
            if words.count >= 2 {
                var lastWord : NSString = words.lastObject as! NSString
                while lastWord.length == 0 && words.count >= 2 {
                    words.removeLastObject()
                    lastWord = words.lastObject as! NSString
                }
                
                if words.count > 1 {
                    let lastLetterRange:NSRange = lastWord.rangeOfComposedCharacterSequencesForRange(NSMakeRange(0, 1));
                    displayString.appendString(String(lastWord.substringWithRange(lastLetterRange)))
                }
            }
        }
        
        let backgroundColor : UIColor = self.randomColor()
        
        self.image = self.imageSnapshotFrom(Text: displayString.uppercaseString, BackgroundColor: backgroundColor, Circular: isCircular, TextAttributes: textAttr!)
    }
    
    
    // MARK: - Private functions
    
    private func fontForFontName(fontName:String?) -> UIFont? {
        let fontSize:CGFloat = (CGRectGetWidth(self.bounds)) * CGFloat(kFontResizingProportion)
        if fontName == nil {
            return UIFont.systemFontOfSize(fontSize)
        } else {
            let rVal : UIFont = UIFont(name: fontName!, size: fontSize)!
            return rVal
        }
    }
    
    private func randomColor() -> UIColor {
        var red = 0.0
        while red < 0.1 || red > 0.84 {
            red = drand48()
        }
        
        var green = 0.0
        while green < 0.1 || green > 0.84 {
            green = drand48()
        }
        
        var blue = 0.0
        while blue < 0.1 || blue > 0.84 {
            blue = drand48()
        }
        
        return UIColor.init(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: 1.0)
    }
    
    private func imageSnapshotFrom(Text text: String, BackgroundColor color: UIColor, Circular isCircular: Bool, TextAttributes textAttributes: [String : AnyObject]) -> UIImage? {
        let scale:CGFloat = UIScreen.mainScreen().scale
        
        var size:CGSize = self.bounds.size
        
        if self.contentMode == UIViewContentMode.ScaleToFill || self.contentMode == UIViewContentMode.ScaleAspectFill || self.contentMode == UIViewContentMode.ScaleAspectFit || self.contentMode == UIViewContentMode.Redraw {
            size.width = CGFloat(floorf(Float(size.width) * Float(scale)) / Float(scale));
            size.height = CGFloat(floorf(Float(size.height) * Float(scale)) / Float(scale));
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        if isCircular {
            //
            // Clip context to a circle
            //
            let path:CGPathRef = CGPathCreateWithEllipseInRect(self.bounds, nil)
            CGContextAddPath(context, path)
            CGContextClip(context)
        }
        
        //
        // Fill background of context
        //
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
        
        //
        // Draw text in the context
        //
        let str = NSString(string: text)
        
        let textSize:CGSize = str.sizeWithAttributes(textAttributes)
        let bounds:CGRect = self.bounds
        
        str.drawInRect(CGRectMake(bounds.size.width/2 - textSize.width/2,
            bounds.size.height/2 - textSize.height/2,
            textSize.width,
            textSize.height), withAttributes: textAttributes)
        
        let snapShot:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapShot
    }
}
