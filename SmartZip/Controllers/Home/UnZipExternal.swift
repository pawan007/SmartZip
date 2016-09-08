//
//  UnZipExternal.swift
//  SmartZip
//
//  Created by Pawan Dhawan on 23/08/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//


import UIKit
import SSZipArchive
import AVKit

class UnZipExternal: NSObject {
    
    var zipFilePath = ""
    var unZipFilePath = ""
    var resourceType = ""
    
    // MARK: UITableview method implementation
    
    func unzipPath(zipPath:String) -> String {
        
        /*guard let unzipPath = tempUnzipPath(zipPath) else {
         return ""
         }*/
        
        //        unZipFilePath = unzipPath
        unZipFilePath = CommonFunctions.sharedInstance.docDirPath()
        
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unZipFilePath)
        
        if !success {
            
            return ""
            
        }else{
            
            return unZipFilePath
            
        }
        
    }
    
    
    func tempUnzipPath(zipPath:String) -> String? {
        
        
        let zipName = zipPath.componentsSeparatedByString("/").last?.replace(".zip", replacementString: "")
        
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        path += "/\(zipName!)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
}
