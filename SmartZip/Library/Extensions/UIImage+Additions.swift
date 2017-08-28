//
//  UIImageAdditions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//


//crop
//oriantation fix
//center squ crop
//blur
//image from color

import UIKit
import ImageIO
import CoreImage
import Accelerate

// MARK: - UIImage Extension

extension UIImage {
    
    /**
     Apply Light effect to UIImage
     
     - returns: New UIImage with applied effect
     */
    func applyLightEffect() -> UIImage? {
        return applyBlurWithRadius(30, tintColor: UIColor(white: 1.0, alpha: 0.3), saturationDeltaFactor: 1.8)
    }
    
    /**
     Apply Extra Light effect to UIImage
     
     - returns: New UIImage with applied effect
     */
    func applyExtraLightEffect() -> UIImage? {
        return applyBlurWithRadius(20, tintColor: UIColor(white: 0.97, alpha: 0.82), saturationDeltaFactor: 1.8)
    }
    
    /**
     Apply Dark effect to UIImage
     
     - returns: New UIImage with applied effect
     */
    func applyDarkEffect() -> UIImage? {
        return applyBlurWithRadius(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)
    }
    
    /**
     Apply Tint Effect with provided color
     
     - parameter tintColor: tint color
     
     - returns: new image with applied effect
     */
    func applyTintEffectWithColor(_ tintColor: UIColor) -> UIImage? {
        let effectColorAlpha: CGFloat = 0.6
        var effectColor = tintColor
        
        let componentCount = tintColor.cgColor.numberOfComponents
        
        if componentCount == 2 {
            var b: CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor(white: b, alpha: effectColorAlpha)
            }
        } else {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        
        return applyBlurWithRadius(10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    /**
     Extracts image at a given rect from an image
     - parameter rect : rect for which UIImage should be extracted within
     - returns : new UIImage created from rect value supplied
     */
    func imageByCroppingAtRect(_ rect:CGRect) -> UIImage? {
        
        let imageRef:CGImage? = self.cgImage?.cropping(to: rect)
        if imageRef == nil {
            return nil
        } else {
            let subImage:UIImage = UIImage(cgImage:imageRef!)
            return subImage
        }
    }
    
    /**
     Creates Image by taking snapshot from View
     - parameter view : View for which snapshot image should be create
     - returns : new UIImage created from View snapshot
     */
    func snapshotImageWithView(_ view:UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale);
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false);
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image;
    }
    
    /**
     Rotates image by degrees
     - parameter degrees : rect for which UIImage should be extracted within
     - returns : new UIImage rotated by degree value supplied
     */
    func imageRotatedByDegrees(_ degrees:CGFloat) -> UIImage? {
        
        let rotatedViewBox : UIView = UIView(frame: CGRect(x: 0,y: 0,width: self.size.width, height: self.size.height))
        
        let rotatedSize : CGSize = rotatedViewBox.frame.size;
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize);
        let  bitmap : CGContext = UIGraphicsGetCurrentContext()!;
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        
        //   // Rotate the image context
        bitmap.rotate(by: (degrees * (CGFloat(M_PI) / 180.0)));
        
        // Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0);
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height));
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    
    /**
     Crops image in square from center
     - parameter imageOrientation : orientation of current image
     - returns : new UIImage by cropping
     */
    func centerMaxSquareImage(_ imageOrientation:UIImageOrientation) -> UIImage? {
        
        var centerSquareSize:CGSize = CGSize.zero;
        let oriImgWid = self.cgImage?.width;
        let oriImgHgt = self.cgImage?.height;
        
        if(oriImgHgt! <= oriImgWid!) {
            centerSquareSize.width = CGFloat(oriImgHgt!) ;
            centerSquareSize.height = CGFloat(oriImgHgt!) ;
        } else {
            centerSquareSize.width = CGFloat(oriImgWid!);
            centerSquareSize.height = CGFloat(oriImgWid!);
        }
        
        let x = (CGFloat(oriImgWid!) - centerSquareSize.width) / 2.0;
        let y = (CGFloat(oriImgHgt!) - centerSquareSize.height) / 2.0;
        
        let cropRect : CGRect = CGRect(x: x, y: y, width: centerSquareSize.height, height: centerSquareSize.width);
        let imageRef : CGImage = self.cgImage!.cropping(to: cropRect)!;
        
        let cropped : UIImage = UIImage(cgImage: imageRef, scale: 0.0, orientation: imageOrientation);
        
        return cropped;
    }
    
    /**
     Get Exif data from image
     - returns : dictionary containing exif data
     */
    func metaDataFromImage() -> NSDictionary? {
        let currentImage = self
        
        let pngData:Data =  UIImageJPEGRepresentation(currentImage, 1.0)!;
        let mySourceRef : CGImageSource = CGImageSourceCreateWithData(pngData as CFData, nil)!;
        let metaData : NSDictionary = CGImageSourceCopyPropertiesAtIndex(mySourceRef, 0, nil)!;
        
        //let exifDic : NSDictionary? = metaData[kCGImagePropertyExifDictionary as String] as? NSDictionary;
        //let tiffDic : NSDictionary? = metaData[kCGImagePropertyTIFFDictionary as String] as? NSDictionary;
        
        return metaData;
    }
    
    /**
     Scales image to a target size with keeping Aspect Ratio intact. If target height is less than target width than origional image will be scaled to match aspect ratio according to height i.e width will be adjusted and might not be same as target width in scaled image
     - parameter targetSize : rect for which UIImage should be extracted within
     - returns : new UIImage created with scaling value supplied
     */
    func imageByScalingToSize(_ targetSize:CGSize, shouldKeepAspectRatioSame:Bool) -> UIImage? {
        let sourceImage:UIImage = self
        var newImage:UIImage 
        
        let sourceImageSize:CGSize = sourceImage.size
        
        let targetWidth:CGFloat = targetSize.width
        let targetHeight:CGFloat = targetSize.height
        
        var scaleFactor:CGFloat = 0.0
        
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        
        var thumbnailPoint:CGPoint = CGPoint(x: 0, y: 0)
        
        if shouldKeepAspectRatioSame {
            
            let sourceWidth:CGFloat = sourceImageSize.width
            let sourceHeight:CGFloat = sourceImageSize.height
            
            if sourceWidth != targetWidth && sourceHeight != targetHeight {
                let widthFactor:CGFloat = targetWidth/sourceWidth
                let heightFactor:CGFloat = targetHeight/sourceHeight
                
                if widthFactor < heightFactor {
                    scaleFactor = widthFactor
                } else {
                    scaleFactor = heightFactor
                }
                
                scaledWidth = sourceWidth * scaleFactor
                scaledHeight = sourceHeight * scaleFactor
                
                if widthFactor < heightFactor {
                    thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
                } else if (widthFactor > heightFactor) {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
                }
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        
        var thumbnailRect:CGRect = CGRect.zero
        
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.draw(in: thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    /**
     
     Fixes UIImage's orientation to Up
     - parameter src : image to be fixed
     - returns : new UIImage with orientation up
     */
    func fixImageOrientation(_ src:UIImage)->UIImage {
        
        if src.imageOrientation == UIImageOrientation.up {
            return src
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch src.imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: src.cgImage!.bitsPerComponent, bytesPerRow: 0, space: src.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    
    /**
     
     creates UIImage from given color and size
     - parameter color : color of image
     - parameter size : ture = size of image
     - returns : new UIImage with color and size
     */
    
    class func imageWithColor(_ color: UIColor, size:CGSize) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
    
     Rotates a source image at a given rect from an image
     - parameter sourceImage : image to be rotated
     - parameter clockwise : ture = clockwise rotated image / false = anti-clockwise rotated image
     - returns : new UIImage with rotation applied
     */
    class func imageByRotating(_ sourceImage:UIImage?,clockwise:Bool) -> UIImage? {
        if sourceImage == nil {
            print("UIImage-Extention -> imageByRotating : source image is nill")
            return nil
        } else {
            let size:CGSize = (sourceImage?.size)!
            UIGraphicsBeginImageContext(size)
            let image:UIImage = UIImage(cgImage: (sourceImage?.cgImage)!, scale: 1.0, orientation:clockwise ? .right : .left)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            return newImage
        }
    }
    
    /**
     
     Rotates a source image at a given rect from an image
     - parameter sourceImage : image to be rotated
     - parameter clockwise : ture = clockwise rotated image / false = anti-clockwise rotated image
     - returns : new UIImage with rotation applied
     */
    class func imageByRotatingToTop(_ sourceImage:UIImage?) -> UIImage? {
        if sourceImage == nil {
            print("UIImage-Extention -> imageByRotating : source image is nill")
            return nil
        } else {
            let size:CGSize = (sourceImage?.size)!
            UIGraphicsBeginImageContext(size)
            let image:UIImage = UIImage(cgImage: (sourceImage?.cgImage)!, scale: 1.0, orientation:.up)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let newImage:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            return newImage
        }
    }
    
    fileprivate func applyBlurWithRadius(_ blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if (size.width < 1 || size.height < 1) {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        if self.cgImage == nil {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if maskImage != nil && maskImage!.cgImage == nil {
            print("*** error: maskImage must be backed by a CGImage: \(maskImage)")
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
        let screenScale = UIScreen.main.scale
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(_ context: CGContext?) -> vImage_Buffer {
                let data = context?.data
                let width = vImagePixelCount((context?.width)!)
                let height = vImagePixelCount((context?.height)!)
                let rowBytes = context?.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes!)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectInContext = UIGraphicsGetCurrentContext()
            
            effectInContext?.scaleBy(x: 1.0, y: -1.0)
            effectInContext?.translateBy(x: 0, y: -size.height)
            effectInContext?.draw(self.cgImage!, in: imageRect)
            
            var effectInBuffer = createEffectBuffer(effectInContext)
            
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = createEffectBuffer(effectOutContext)
            
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                
                let inputRadius = blurRadius * screenScale
                var radius = UInt32(floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i: Int in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext?.draw(self.cgImage!, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()
            if let image = maskImage {
                outputContext?.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(color.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
}
