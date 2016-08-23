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
        
        guard let unzipPath = tempUnzipPath(zipPath) else {
            return ""
        }
        
        unZipFilePath = unzipPath
        
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unzipPath)
        
        if !success {
            
            return ""
            
        }else{
            
            return unZipFilePath
            
        }
        
    }
    
    
    func tempUnzipPath(zipPath:String) -> String? {
        
        /*var folderName = ""
         
         if zipPath.containsString("Images") {
         
         folderName = "Images-\(Timestamp)"
         resourceType = ResTypeImage
         
         }else if zipPath.containsString("Videos") {
         
         folderName = "Videos-\(Timestamp)"
         resourceType = ResTypeVideo
         
         }else if zipPath.containsString("Song") {
         
         folderName = "Song-\(Timestamp)"
         resourceType = ResTypeAudio
         
         }else{
         
         folderName = "Dock-\(Timestamp)"
         resourceType = ResTypeDoc
         
         }*/
        
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
