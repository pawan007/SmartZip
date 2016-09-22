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
        //        unZipFilePath = CommonFunctions.sharedInstance.docDirPath()
        
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
            return CommonFunctions.sharedInstance.docDirPath()
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
    
    func unzipPathInner(zipPath:String) -> String {
        
        guard let unzipPath = tempUnzipPathInner(zipPath) else {
            return ""
        }
        
        unZipFilePath = unzipPath
        //        unZipFilePath = CommonFunctions.sharedInstance.docDirPath()
        
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unZipFilePath)
        
        if !success {
            
            return ""
            
        }else{
            
            return unZipFilePath
            
        }
        
    }
    
    
    func unzipPathInner(zipPath:String, unzipPath:String) -> String {
        
        unZipFilePath = unzipPath
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unZipFilePath)
        if !success {
            return ""
        }else{
            return unZipFilePath
        }
        
    }
    
    
    func tempUnzipPathInner(zipPath:String) -> String? {
        
        
//        let zipName = zipPath.componentsSeparatedByString("/").last?.replace(".zip", replacementString: "")
        let folderPath = zipPath.stringByReplacingOccurrencesOfString(".zip", withString: "")
//        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        print(zipName)
        print(folderPath)
//        print(path)
//        folderPath += "/\(zipName!)"
        
        
        if !NSFileManager.defaultManager().fileExistsAtPath(folderPath) {
            
            let url = NSURL(fileURLWithPath: folderPath)
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return CommonFunctions.sharedInstance.docDirPath()
            }
            if let path = url.path {
                return path
            }
            
        }else{
            
            let incCount = getFileCopiesCount(folderPath)
            let newPath = "\(folderPath)-\(incCount)"
            let url = NSURL(fileURLWithPath: newPath)
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return CommonFunctions.sharedInstance.docDirPath()
            }
            if let path = url.path {
                return path
            }
        }
        
        
        
        
        
        return nil
    }
    
    func getFileCopiesCount(path:String) -> Int {
        
        var folderHierarchy = path.componentsSeparatedByString("/")
        folderHierarchy.removeLast()
        let pathParent = folderHierarchy.joinWithSeparator("/")
        var count = 0
        if let enumerator = NSFileManager.defaultManager().enumeratorAtPath(pathParent) {
            while let fileName = enumerator.nextObject() as? String {
                
                let filePath = "\(pathParent)/\(fileName)"
                if filePath.containsString(path) && path.componentsSeparatedByString("/").count == filePath.componentsSeparatedByString("/").count{
                    print(filePath)
                    count = count + 1
                }
            }
        }
        return count
    }
    
}
