//
//  FBFile.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit

/// FBFile is a class representing a file in FileBrowser
open class FBFile: NSObject {
    /// Display name. String.
    open let displayName: String
    // is Directory. Bool.
    open let isDirectory: Bool
    /// File extension.
    open let fileExtension: String?
    /// File attributes (including size, creation date etc).
    open let fileAttributes: NSDictionary?
    /// NSURL file path.
    open let filePath: URL
    // FBFileType
    open let type: FBFileType
    
    open var isChecked = false
    
    /**
     Initialize an FBFile object with a filePath
     
     - parameter filePath: NSURL filePath
     
     - returns: FBFile object.
     */
    init(filePath: URL) {
        self.filePath = filePath
        let isDirectory = checkDirectory(filePath)
        self.isDirectory = isDirectory
        if self.isDirectory {
            self.fileAttributes = nil
            self.fileExtension = nil
            self.type = .Directory
        }
        else {
            self.fileAttributes = getFileAttributes(self.filePath)
            self.fileExtension = filePath.pathExtension
            if let fileExtension = fileExtension {
                self.type = FBFileType(rawValue: fileExtension) ?? .Default
            }
            else {
                self.type = .Default
            }
        }
        self.displayName = filePath.lastPathComponent ?? String()
    }
}

/**
 FBFile type
 */
public enum FBFileType: String {
    /// Directory
    case Directory = "directory"
    /// GIF file
    case gif = "gif"
    case GIF = "GIF"
    /// JPG file
    case jpg = "jpg"
    case JPG = "JPG"
    case jpeg = "jpeg"
    case JPEG = "JPEG"
    /// PLIST file
    case json = "json"
    case JSON = "JSON"
    /// PDF file
    case pdf = "pdf"
    case PDF = "PDF"
    /// PLIST file
    case plist = "plist"
    case PLIST = "PLIST"
    /// PNG file
    case png = "png"
    case PNG = "PNG"
    case doc = "doc"
    case DOC = "DOC"
    case txt = "txt"
    case TXT = "TXT"
    /// ZIP file
    case zip = "zip"
    case ZIP = "ZIP"
    
    case mp3 = "mp3"
    case wav = "wav"
    case MP3 = "MP3"
    case WAV = "WAV"
    
    case m4v = "m4v"
    case mp4 = "mp4"
    case mov = "mov"
    case M4V = "M4V"
    case MP4 = "MP4"
    case MOV = "MOV"
    
    /// Any file
    case Default = "file"
    
    /**
     Get representative image for file type
     
     - returns: UIImage for file type
     */
    public func image() -> UIImage? {
        let bundle =  Bundle(for: FileParser.self)
        var fileName = String()
        switch self {
        case .Directory: fileName = "myfolder"
//        case JPG, jpg, JPEG, jpeg, PNG, png, GIF, gif: fileName = "image"
        case .JPG, .jpg : fileName = "jpg"
        case .PNG, .png : fileName = "png"
        case .GIF, .gif : fileName = "gif"
        case .PDF, .pdf: fileName = "pdf"
        case .DOC, .doc: fileName = "doc"
            case .TXT, .txt: fileName = "txt"
        case .ZIP, .zip: fileName = "zip"
            
        case .mp3, .MP3,.WAV,.wav: fileName = "music"
        case .m4v, .M4V, .mp4, .MP4, .MOV, .mov: fileName = "video"
            
            
        default: fileName = "fileIcon"
        }
        let file = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        return file
    }
}

/**
 Check if file path NSURL is directory or file.
 
 - parameter filePath: NSURL file path.
 
 - returns: isDirectory Bool.
 */
func checkDirectory(_ filePath: URL) -> Bool {
    var isDirectory = false
    do {
        var resourceValue: AnyObject?
        try (filePath as NSURL).getResourceValue(&resourceValue, forKey: URLResourceKey.isDirectoryKey)
        if let number = resourceValue as? NSNumber, number == true {
            isDirectory = true
        }
    }
    catch { }
    return isDirectory
}

func getFileAttributes(_ filePath: URL) -> NSDictionary? {
    guard filePath.path.length != 0 else {
        return nil
    }
    let fileManager = FileParser.sharedInstance.fileManager
    do {
        let attributes = try fileManager.attributesOfItem(atPath: filePath.path) as NSDictionary
        return attributes
    } catch {}
    return nil
}
