//
//  PhotoPickerVC.swift
//  SwiftExample
//
//  Created by Pawan Dhawan on 15/06/16.
//
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AssetsLibrary
import SSZipArchive
//import SwiftSpinner
import QBImagePickerController

class PhotoPickerVC: UIViewController, QBImagePickerControllerDelegate {
    
    var flagImage = false
    var flagVideo = false
    var totalItem = 0
    var currentItem = 0
    var folderDir = ""
    var isLastIndex = false
    var totalfileCount = 0
    var currentFile = 0
    var nameIndex = 0
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoPickerVC.updateVideoStatus), name: NSNotification.Name(rawValue: "check_slow_video"), object: nil)
        
    }
    
    
    @IBAction func selectPhotos (_ sender:AnyObject!) {
        
        let imagePicker = QBImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaType = QBImagePickerMediaType.Image
        imagePicker.allowsMultipleSelection = true
        imagePicker.showsNumberOfSelectedAssets = true
        flagImage = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func useDropBox(_ sender:AnyObject!) {
        
        let vc = UIStoryboard.dropBoxVC()
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func selectVideos (_ sender:AnyObject!) {
        
        let imagePicker = QBImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaType = QBImagePickerMediaType.Video
        imagePicker.allowsMultipleSelection = true
        imagePicker.showsNumberOfSelectedAssets = true
        flagVideo = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func selectAudio(_ sender: AnyObject) {
        
        let picker = MPMediaPickerController(mediaTypes:.music)
        picker.showsCloudItems = false
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        picker.modalPresentationStyle = .popover
        picker.preferredContentSize = CGSize(width: 500,height: 600)
        self.present(picker, animated: true, completion: nil)
        if let pop = picker.popoverPresentationController {
            if let b = sender as? UIBarButtonItem {
                pop.barButtonItem = b
            }
        }
        
    }
    
    
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        
        flagVideo = false
        flagImage = false
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        
        print(assets)
        self.dismiss(animated: true, completion: nil)
        
        if flagImage {
            
            /*for item in assets{
             
             let asset = item as! PHAsset
             
             asset.requestContentEditingInputWithOptions(PHContentEditingInputRequestOptions()) { (input, _) in
             let url = input!.fullSizeImageURL
             print(url)
             }
             }*/
            
            self.dismiss(animated: true, completion: nil)
            zipAndShareImages(assets)
            
        }else{
            
            self.dismiss(animated: true, completion: nil)
            zipAndShareVideos(assets)
        }
        
        flagVideo = false
        flagImage = false
    }
    
    
    
    func zipAndShareImages(_ assets: [AnyObject]!) {
        
        var folderName = ""
        
        if assets.count > 0 {
            
//            deleteAllFilesInDirectory(NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])
            
            folderName = "Images-\(Timestamp)"
//            var cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(folderName)"
            
            do{
                try FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
            }catch let e as NSError{
                print(e)
            }
            
            let totalItem = assets.count
            var currentItem = 0
            
            for item in assets{
                
                let asset = item as! PHAsset
                asset.requestContentEditingInputWithOptions(PHContentEditingInputRequestOptions()) { (input, _) in
                    let url = input!.fullSizeImageURL
                    print(url)
                    
                    do{
                        let array = url?.path?.componentsSeparatedByString("/")
                        let name = array!.last! as String
                        let selectedVideo = NSURL(fileURLWithPath:"\(cacheDir)/\(name)")
                        try NSFileManager.defaultManager().copyItemAtURL(url!, toURL: selectedVideo)
                        
                        currentItem += 1
                        
                        if currentItem == totalItem{
                            
                            let newPath = cacheDir + ".zip"
                            self.zipMyFiles(newPath, existingFolder: cacheDir)
                        }
                        
                    }catch let e as NSError{
                        print(e)
                    }
                    
                }
            }
            
        }else{
            
            print("Song not selected")
            
        }
        
    }
    
    func zipAndShareVideos(_ assets: [AnyObject]!) {
        
        var folderName = ""
        
        if assets.count > 0 {
            
            
//            deleteAllFilesInDirectory(NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])
            
            SwiftSpinner.show("Processing, please wait..")

            
            folderName = "Videos-\(Timestamp)"
//            var cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(folderName)"
            
            do{
                try FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
            }catch let e as NSError{
                print(e)
            }
            
            totalItem = assets.count
            currentItem = 0
            
            
            
            for item in assets{
                
                let asset = item as! PHAsset
                
                nameIndex += 1
                
                PHImageManager.defaultManager().requestAVAssetForVideo(asset, options: nil, resultHandler: { (asset, audioMix, response) -> Void in
                    
                    if (asset != nil &&  asset!.isKindOfClass(AVURLAsset.classForCoder()) ){
                        
                        let newVal = asset as! AVURLAsset
                        let url = newVal.URL
                        print(url)
                        
                        do{
                            let array = url.path?.componentsSeparatedByString("/")
                            let name = array!.last! as String
                            let selectedVideo = NSURL(fileURLWithPath:"\(cacheDir)/\(name)")
                            try NSFileManager.defaultManager().copyItemAtURL(url, toURL: selectedVideo)
                            self.currentItem += 1
                            
                            print("in normal motion cur item = \(self.currentItem)")
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if self.currentItem == self.totalItem{
                                    SwiftSpinner.hide()
                                    self.currentItem = 0
                                    self.totalItem = 0
                                    let newPath = cacheDir + ".zip"
                                    self.zipMyFiles(newPath, existingFolder: cacheDir)
                                }
                                
                            })
                            
                        }catch let e as NSError{
                            print(e)
                        }
                        
                    }else if (asset != nil &&  asset!.isKindOfClass(AVComposition.classForCoder()) ){
                        
                        let path = "\(cacheDir)/mergeSlowMoVideo_\(self.nameIndex).mov"
                        self.folderDir = cacheDir
                        self.getSlowMotionVideo(asset!, filePath: path,cacheDir: cacheDir,totalItem: self.totalItem, currentItem: self.currentItem)
                        
                    }
                    
                })
                
            }
            
        }else{
            
            print("video not selected")
            
        }
        
        
        
        
    }
    
    
    
    func getSlowMotionVideo(_ asset:AVAsset , filePath:String, cacheDir:String , totalItem:Int, currentItem:Int) -> Void {
        
        objc_sync_enter(self)
        
        let fileUrl = URL(fileURLWithPath: filePath)
        
        let exporter = AVAssetExportSession(asset: asset, presetName:AVAssetExportPresetHighestQuality)
        exporter?.outputURL = fileUrl
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        exporter?.shouldOptimizeForNetworkUse = true
        
        objc_sync_exit(self)
        
        exporter?.exportAsynchronously(completionHandler: { () -> Void in
            
            objc_sync_enter(self)
            
            if exporter?.status == AVAssetExportSessionStatus.completed{
                
                objc_sync_exit(self)
                print(exporter?.outputURL)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "check_slow_video"), object: nil)
                
                
            }else{
                
                print("Error occured while generating video zip")
                objc_sync_exit(self)
                
                DispatchQueue.main.async(execute: {
                    
                    SwiftSpinner.hide()
                    
                })
            }
            
            
        })
        
    }
    
    
    func updateVideoStatus() {
        
        
        DispatchQueue.main.async(execute: {
            
            self.currentItem += 1
            
            if self.currentItem == self.totalItem{
                SwiftSpinner.hide()
                self.currentItem = 0
                self.totalItem = 0
                let newPath = self.folderDir + ".zip"
                self.zipMyFiles(newPath, existingFolder: self.folderDir)
            }
            
        })
        
        
        
    }
    
    /*func validateFileSize(assets: [AnyObject]!) -> Void {
     
     let fileSize = try! NSFileManager.defaultManager().attributesOfItemAtPath(fileURL.path!)[NSFileSize]!.longLongValue
     
     for item in assets{
     
     let asset = item as! PHAsset
     asset.requestContentEditingInputWithOptions(PHContentEditingInputRequestOptions()) { (input, _) in
     let url = input!.fullSizeImageURL
     print(url)
     }
     }
     
     }*/
    
    func zipMyFiles(_ newZipFile:String, existingFolder:String) {
        
        
        if !CommonFunctions.sharedInstance.canCreateZip(existingFolder) {
            
            try! kFileManager.removeItem(atPath: existingFolder)
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "You do not have enough space to create zip file", vc: self)
            return
        }
        
        let success = SSZipArchive.createZipFileAtPath(newZipFile, withContentsOfDirectory: existingFolder)
        if success {
            try! FileManager.default.removeItem(atPath: existingFolder)
            print("Zip file created successfully")
            self.shareMyFile(newZipFile)
            
            /*let vc:UnZipVC = UIStoryboard.unZipVC()!
             vc.zipFilePath = newZipFile
             self.navigationController?.pushViewController(vc, animated: true)*/
            
        }
        
    }
    
    func shareMyFile(_ zipPath:String) -> Void {
        
        let fileDAta = URL(fileURLWithPath: zipPath)
        
        let name = (zipPath.components(separatedBy: "/").last)!
        let myWebsite = URL(string: "https://itunes.apple.com/us/app/smartzip/id1141913794?ls=1&mt=8")
        let ac = UIActivityViewController(activityItems: [fileDAta,"SmartZip File \(name)", myWebsite!] , applicationActivities: nil)
        ac.excludedActivityTypes = [UIActivityType.print, UIActivityType.copyToPasteboard,UIActivityType.assignToContact, UIActivityType.saveToCameraRoll]
        ac.setValue("My file", forKey: "Subject")
        
        if let popoverPresentationController = ac.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            var rect=self.view.frame
            rect.origin.y = rect.height
            popoverPresentationController.sourceRect = rect
        }
        self.present(ac, animated: true, completion: nil)
        
    }
    
    func deleteAllFilesInDirectory(_ directoryPath:String) -> Void {
        
        if let enumerator = FileManager.default.enumerator(atPath: directoryPath) {
            while let fileName = enumerator.nextObject() as? String {
                do {
                    try FileManager.default.removeItem(atPath: "\(directoryPath)\(fileName)")
                }
                catch let e as NSError {
                    print(e)
                }
                catch {
                    print("error")
                }
            }
        }
        
    }
    
    
    
}

extension PhotoPickerVC : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        print("did pick")
        getSongsAdvance(mediaItemCollection)
        self.dismiss(animated: true, completion: nil)
        return
        
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSongsAdvance(_ mediaItemCollection: MPMediaItemCollection) {
    
        var folderName = ""
        
        if mediaItemCollection.items.count > 0 {
            
//            deleteAllFilesInDirectory(NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])
            
            folderName = "Song-\(Timestamp)"
//            var cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(folderName)"
            
            do{
                try FileManager.default.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
            }catch let e as NSError{
                print(e)
            }
            
            for item in mediaItemCollection.items{
                
                if item ==  mediaItemCollection.items.last{
                    isLastIndex = true
                }
                
                if item ==  mediaItemCollection.items.first{
                    SwiftSpinner.show("Processing, please wait..")
                    currentFile = 0
                    totalfileCount = mediaItemCollection.items.count
                }
                
                print(item.assetURL)
                let filePath = "\(cacheDir)/\(item.title!).m4a"
                let myFileUrl = URL(fileURLWithPath: filePath)
                saveAssetUrlToMp3(item.assetURL!, path: myFileUrl, title: item.title!, parentDir: cacheDir)
                
            }
            
            
        }else{
            
            print("Song not selected")
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func saveAssetUrlToMp3(_ assetUrl:URL, path:URL, title:String, parentDir:String) {
        
        let songAsset = AVURLAsset(url: assetUrl, options: nil)
        let exporter = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetPassthrough)
        exporter!.outputFileType = "com.apple.quicktime-movie";
        exporter?.outputURL = path
        exporter?.shouldOptimizeForNetworkUse = true
        
        exporter?.exportAsynchronously( completionHandler: { () -> Void in
            
            if(exporter?.status == AVAssetExportSessionStatus.completed){
                
                let filePath = "\(parentDir)/\(title).m4a"
                var fileSize : UInt64 = 0
                do {
                    let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary?
                    if let _attr = attr {
                        fileSize = _attr.fileSize();
                        print("fileSize: \(fileSize)")
                    }
                    var newFilePath = ""
                    if title.contains(".mp3"){
                        newFilePath = filePath.replacingOccurrences(of: ".m4a", with: "")
                    }else{
                        newFilePath = filePath.replacingOccurrences(of: ".m4a", with: ".mp3")
                    }
                    try! FileManager.default.moveItem(atPath: filePath, toPath: newFilePath)
                    
                } catch {
                    print("Error: \(error)")
                }
                
                DispatchQueue.main.async(execute: {
                    
                    self.currentFile += 1
                    if self.currentFile == self.totalfileCount {
                        SwiftSpinner.hide()
                        self.currentFile = 0
                        self.totalfileCount = 0
                        self.isLastIndex = false
                        let newPath = parentDir + ".zip"
                        self.zipMyFiles(newPath, existingFolder: parentDir)
                        
                    }
                    
                })
                
                
                
            }else{
                
                print("error: \(exporter?.error?.localizedFailureReason)")
                
                DispatchQueue.main.async(execute: {
                    
                    self.currentFile += 1
                    if self.currentFile == self.totalfileCount {
                        SwiftSpinner.hide()
                    }
                    
                })
                
            }
        })
    }
    
    
    
}
