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
    
    func unzipPath(_ zipPath:String) -> String {
        
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
    
    
    func tempUnzipPath(_ zipPath:String) -> String? {
        
        
        let zipName = zipPath.components(separatedBy: "/").last?.replace(".zip", replacementString: "")
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path += "/\(zipName!)"
        let url = URL(fileURLWithPath: path)
        
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return CommonFunctions.sharedInstance.docDirPath()
        }
        
        if let path = url.path {
            return path
        }
        
        return nil
    }
    
    
    func unzipPathInner(_ zipPath:String) -> String {
        
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
    
    
    func unzipPathInner(_ zipPath:String, unzipPath:String) -> String {
        
        unZipFilePath = unzipPath
        let success = SSZipArchive.unzipFileAtPath(zipPath, toDestination: unZipFilePath)
        if !success {
            return ""
        }else{
            return unZipFilePath
        }
        
    }
    
    
    func tempUnzipPathInner(_ zipPath:String) -> String? {
        
        
//        let zipName = zipPath.componentsSeparatedByString("/").last?.replace(".zip", replacementString: "")
        let folderPath = zipPath.replacingOccurrences(of: ".zip", with: "")
//        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        print(zipName)
        print(folderPath)
//        print(path)
//        folderPath += "/\(zipName!)"
        
        
        if !FileManager.default.fileExists(atPath: folderPath) {
            
            let url = URL(fileURLWithPath: folderPath)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return CommonFunctions.sharedInstance.docDirPath()
            }
            if let path = url.path {
                return path
            }
            
        }else{
            
            let incCount = getFileCopiesCount(folderPath)
            let newPath = "\(folderPath)-\(incCount)"
            let url = URL(fileURLWithPath: newPath)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return CommonFunctions.sharedInstance.docDirPath()
            }
            if let path = url.path {
                return path
            }
        }
        
        
        
        
        
        return nil
    }
    
    func getFileCopiesCount(_ path:String) -> Int {
        
        var folderHierarchy = path.components(separatedBy: "/")
        folderHierarchy.removeLast()
        let pathParent = folderHierarchy.joined(separator: "/")
        var count = 0
        if let enumerator = FileManager.default.enumerator(atPath: pathParent) {
            while let fileName = enumerator.nextObject() as? String {
                
                let filePath = "\(pathParent)/\(fileName)"
                if filePath.contains(path) && path.components(separatedBy: "/").count == filePath.components(separatedBy: "/").count{
                    print(filePath)
                    count = count + 1
                }
            }
        }
        return count
    }
    
}
