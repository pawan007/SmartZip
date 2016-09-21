//
//  HomeVCNew.swift
//  SmartZip
//
//  Created by Pawan Dhawan on 15/09/16.
//  Copyright © 2016 Pawan Kumar. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AssetsLibrary
import SSZipArchive
import SwiftSpinner
import QBImagePickerController
//import NADocumentPicker

import GoogleMobileAds


class HomeVCNew: UIViewController, QBImagePickerControllerDelegate {
    
    var flagImage = false
    var flagVideo = false
    var totalItem = 0
    var currentItem = 0
    var folderDir = ""
    var isLastIndex = false
    var totalfileCount = 0
    var currentFile = 0
    var nameIndex = 0
    var slowMotionVideoCount = 0
    var isCalledVideoCheck = false
    
    
    var isOpenedFromExternalResource = false
    
    var selectVideo:[AnyObject]?
    
    
    @IBOutlet var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var _bView: UIView!
    var shared:GADMasterViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.setAnimationsEnabled(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoPickerVC.updateVideoStatus), name: "check_slow_video", object: nil)
        
        if APPDELEGATE.isOpenedFromExternalResource {
            isOpenedFromExternalResource = true
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if isOpenedFromExternalResource {
            isOpenedFromExternalResource = false
            //            self.tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
        }
        
        if(!CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedFullPageAds)) {
            if(interstitial != nil) {
                interstitial = nil
            }
            interstitial = GADInterstitial(adUnitID: kGoogleInterstitialAd)
            let request = GADRequest()
            // Request test ads on devices you specify. Your test device ID is printed to the console when
            // an ad request is made.
            // request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
            interstitial.loadRequest(request)
        }
        
        if (!CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            if(shared != nil) {
                shared = nil
            }
            shared = GADMasterViewController.singleton()
            shared.resetAdView(self, andDisplayView: _bView)
        }
        if (CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            
            if(shared != nil) {
                shared = nil
            }
            _bView.hidden = true
        }
        
        // self.setUpGoogleAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        print("Ad changed")
        /*
         for(UIView *tempView in [adsView subviews]) {
         [tempView removeFromSuperview];
         }
         [adsView addSubview:view];
         */
        
        for tempView in _bView.subviews {
            tempView.removeFromSuperview()
        }
        /*
         UIView.animateWithDuration(0.25) { () -> Void in
         bannerView.alpha = 1.0
         self._bView.addSubview(bannerView)
         }
         */
        self._bView.addSubview(bannerView)
        // self.animation(bannerView)
    }
    
    func animation(animationView:UIView) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
                animation.fromValue = 0;
                animation.toValue = 2 * M_PI;
                animation.repeatCount = 1;//INFINITY;
                animation.duration = 0.5;
                animationView.layer.addAnimation(animation, forKey: "rotation")
            }
        }
        /*
         var transform:CATransform3D = CATransform3DIdentity;
         transform.m34 = 1.0 / 500.0;
         animationView.layer.transform = transform;
         */
    }
    
    func setUpGoogleAds() {
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = kGoogleBannerAdId
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
        
        interstitial = GADInterstitial(adUnitID: kGoogleInterstitialAd)
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
        // request.testDevices = [ kGADSimulatorID, "2077ef9a63d2b398840261c8221a0c9b" ]
        interstitial.loadRequest(request)
    }
    
    func showFullPageAd() -> Bool {
        let str = "TipsPopupValue"
        var isShow = false
        if  NSUserDefaults.standardUserDefaults().objectForKey(str) != nil {
            var val = NSUserDefaults.standardUserDefaults().objectForKey(str)?.integerValue
            val = val! - 1
            if(val == 0) {
                isShow = true
                let number = self.randomInt(1, max: 4)
                NSUserDefaults.setObject(number, forKey: str)
            }
            else {
                NSUserDefaults.setObject(val, forKey: str)
            }
            
        }
        else {
            let number = self.randomInt(1, max: 4)
            NSUserDefaults.setObject(number, forKey: str)
        }
        
        if(isShow) {
            if interstitial.isReady && (!CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedFullPageAds)){
                interstitial.presentFromRootViewController(self)
            } else {
                print("Ad wasn't ready")
                isShow = false
            }
            
            /*
             let viewsDictionary = ["subView":interstitial]
             let view_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat(
             "H:|[subView]|",
             options: NSLayoutFormatOptions(rawValue:0),
             metrics: nil, views: viewsDictionary)
             let view_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
             "V:|[subView]|",
             options: NSLayoutFormatOptions.AlignAllLeading,
             metrics: nil, views: viewsDictionary)
             
             APPDELEGATE.window?.addConstraints(view_constraint_H)
             APPDELEGATE.window?.addConstraints(view_constraint_V)
             */
        }
        return isShow
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    /*override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     print("didSelectRowAtIndexPath\(indexPath.row)")
     
     if indexPath.section == 0 {
     
     if indexPath.row == 0 {
     // File
     handleLocalFile()
     
     }else if indexPath.row == 1 {
     // photos
     selectPhotos()
     
     }else if indexPath.row == 2 {
     // videos
     selectVideos()
     
     }else if indexPath.row == 3 {
     // Audio
     selectAudio()
     }
     
     }else{
     
     if indexPath.row == 0 {
     
     guard Reachability.isConnectedToNetwork()else{
     CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
     return
     }
     
     useDropBox()
     
     }else if indexPath.row == 1 {
     
     guard Reachability.isConnectedToNetwork()else{
     CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
     return
     }
     useGoogle()
     
     }else if indexPath.row == 2 {
     
     
     let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.text"], inMode: .Import)
     
     importMenu.delegate = self
     
     self.presentViewController(importMenu, animated: true, completion: nil)
     
     let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data", "public.text"], inMode: .Import)
     
     documentPicker.delegate = self
     
     documentPicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
     
     self.presentViewController(documentPicker, animated: true, completion: nil)
     
     
     guard Reachability.isConnectedToNetwork()else{
     CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
     return
     }
     useMoreCloud()
     }
     
     }
     
     
     
     }*/
    
    
    
    @IBAction   func menuButtonAction(sender: AnyObject) {
        if (self.showFullPageAd()) {
            return;
        }
        else {
            if let container = SideMenuManager.sharedManager().container {
                container.toggleDrawerSide(.Left, animated: true) { (val) -> Void in
                    
                }
            }
        }
    }
    
    func handleLocalFile() {
        
        /*let fileBrowser = FileBrowser()
         fileBrowser.excludesFileExtensions = ["zip"]
         self.presentViewController(fileBrowser, animated: true, completion: nil)
         fileBrowser.didSelectFile = { (file: FBFile) -> Void in
         print(file.displayName)
         }*/
        
        FileParser.sharedInstance.currentPath = FileParser.sharedInstance.documentsURL()
        let fileListViewController = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("FileListViewController")
        APPDELEGATE.flvc = fileListViewController as? FileListViewController
        self.navigationController?.pushViewController(fileListViewController, animated: true)
        
        let flurryParams = [ "Type" :"handleLocalFile"]
        AnalyticsManager.sharedManager().trackEvent("MediaTypeSelected", attributes: flurryParams, screenName: "AppDelegate")
        
    }
    
    func selectPhotos () {
        
        let imagePicker = QBImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaType = QBImagePickerMediaType.Image
        imagePicker.allowsMultipleSelection = true
        imagePicker.showsNumberOfSelectedAssets = true
        flagImage = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        let flurryParams = [ "Type" :"selectPhotos"]
        AnalyticsManager.sharedManager().trackEvent("MediaTypeSelected", attributes: flurryParams, screenName: "AppDelegate")
    }
    
    
    func useDropBox() {
        
        let vc = UIStoryboard.dropBoxVC()
        self.navigationController?.pushViewController(vc!, animated: true)
        let flurryParams = [ "Type" :"useDropBox"]
        AnalyticsManager.sharedManager().trackEvent("MediaTypeSelected", attributes: flurryParams, screenName: "AppDelegate")
        
    }
    
    func useGoogle() {
        
        let vc = UIStoryboard.googleDriveVC()
        self.navigationController?.pushViewController(vc!, animated: true)
        
        let flurryParams = [ "Type" :"useGoogle"]
        AnalyticsManager.sharedManager().trackEvent("MediaTypeSelected", attributes: flurryParams, screenName: "AppDelegate")
        
    }
    
    
    func selectVideos () {
        
        let imagePicker = QBImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaType = QBImagePickerMediaType.Video
        imagePicker.allowsMultipleSelection = true
        imagePicker.showsNumberOfSelectedAssets = true
        flagVideo = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        let flurryParams = [ "Type" :"selectVideos"]
        AnalyticsManager.sharedManager().trackEvent("MediaTypeSelected", attributes: flurryParams, screenName: "AppDelegate")
        
    }
    
    func selectAudio() {
        
        let picker = MPMediaPickerController(mediaTypes:.Music)
        picker.showsCloudItems = false
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        picker.modalPresentationStyle = .Popover
        picker.preferredContentSize = CGSizeMake(500,600)
        self.presentViewController(picker, animated: true, completion: nil)
        
        let flurryParams = [ "Type" :"selectAudio"]
        AnalyticsManager.sharedManager().trackEvent("MediaTypeSelected", attributes: flurryParams, screenName: "AppDelegate")
        
    }
    /*
     func useMoreCloud( ) {
     // user url path..Please handle url
     let urlPickedfuture = NADocumentPicker.show(from: self.view, parentViewController: self)
     urlPickedfuture.onSuccess { url in
     print("URL: \(url)")
     if let urlCloud = NSURL(string: String(url)) {
     let dataFromURL = NSData(contentsOfURL: urlCloud)
     print(urlCloud.lastPathComponent ?? "")
     let filemanager = NSFileManager.defaultManager()
     let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
     let destinationPath:NSString = documentsPath.stringByAppendingString(urlCloud.lastPathComponent!)
     if (!filemanager.fileExistsAtPath(destinationPath as String)) {
     dataFromURL?.writeToFile(destinationPath as String, atomically:true)
     CommonFunctions.sharedInstance.zipMyFiles("\(destinationPath).zip", filePath: destinationPath as String, vc: self)
     } else {
     print("The files already exist")
     }
     }
     }
     
     let flurryParams = [ "Type" :"selectMoreCloud"]
     AnalyticsManager.sharedManager().trackEvent("MediaTypeSelected", attributes: flurryParams, screenName: "AppDelegate")
     }
     */
    
    func qb_imagePickerControllerDidCancel(imagePickerController: QBImagePickerController!) {
        
        flagVideo = false
        flagImage = false
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func qb_imagePickerController(imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        
        
        
        
        if flagImage {
            
            /*for item in assets{
             
             let asset = item as! PHAsset
             
             asset.requestContentEditingInputWithOptions(PHContentEditingInputRequestOptions()) { (input, _) in
             let url = input!.fullSizeImageURL
             print(url)
             }
             }*/
            
            self.dismissViewControllerAnimated(true, completion: nil)
            showEnterNameAlert("Images-"+Timestamp,assets: assets, type: fileTypeImage)
            //
            //            self.dismissViewControllerAnimated(true, completion: nil)
            //            zipAndShareImages(assets)
            
        }else{
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            selectVideo = assets
            canCreateVideo(selectVideo)
            
        }
        
        flagVideo = false
        flagImage = false
    }
    
    
    
    func zipAndShareImages(assets: [AnyObject]!, folderName:String) {
        
        //        var folderName = ""
        
        if assets.count > 0 {
            
            SwiftSpinner.show("Processing, please wait..")
            //            deleteAllFilesInDirectory(NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])
            
            //            folderName = "Images-\(Timestamp)"
            //            var cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(folderName)"
            
            do{
                try kFileManager.createDirectoryAtPath(cacheDir, withIntermediateDirectories: false, attributes: nil)
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
                        
                        if(!kFileManager.fileExistsAtPath(selectedVideo.path!)){
                            try kFileManager.copyItemAtURL(url!, toURL: selectedVideo)
                        }
                        currentItem += 1
                        
                        if currentItem == totalItem{
                            
                            SwiftSpinner.hide()
                            let newPath = cacheDir + ".zip"
                            self.zipMyFiles(newPath, existingFolder: cacheDir)
                        }
                        
                    }catch let e as NSError{
                        print(e)
                        SwiftSpinner.hide()
                    }
                    
                }
            }
            
        }else{
            
            print("Song not selected")
            
        }
        
    }
    
    func zipAndShareVideos(assets: [AnyObject]!, folderName:String) {
        
        //        var folderName = ""
        
        if assets.count > 0 {
            
            
            
            SwiftSpinner.show("Processing, please wait..")
            
            
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(folderName)"
            
            do{
                try kFileManager.createDirectoryAtPath(cacheDir, withIntermediateDirectories: false, attributes: nil)
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
                            try kFileManager.copyItemAtURL(url, toURL: selectedVideo)
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
                            SwiftSpinner.hide()
                        }
                        
                    }else if (asset != nil &&  asset!.isKindOfClass(AVComposition.classForCoder()) ){
                        
                        let path = "\(cacheDir)/SlowMotionVideo_\(self.nameIndex).mov"
                        self.folderDir = cacheDir
                        self.getSlowMotionVideo(asset!, filePath: path,cacheDir: cacheDir,totalItem: self.totalItem, currentItem: self.currentItem)
                        
                    }
                    
                })
                
            }
            
        }else{
            
            print("video not selected")
            
        }
        
        
        
        
    }
    
    
    
    
    func canCreateVideo(assets: [AnyObject]!){
        
        totalItem = assets.count
        currentItem = 0
        self.slowMotionVideoCount = 0
        self.isCalledVideoCheck = false
        
        for item in assets{
            
            let asset = item as! PHAsset
            
            PHImageManager.defaultManager().requestAVAssetForVideo(asset, options: nil, resultHandler: { (asset, audioMix, response) -> Void in
                
                if (asset != nil &&  asset!.isKindOfClass(AVURLAsset.classForCoder()) ){
                    
                    self.currentItem += 1
                    print("in normal Video cur item = \(self.currentItem)")
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if self.currentItem == self.totalItem{
                            if (self.isCalledVideoCheck == false){
                                self.isCalledVideoCheck = true
                                self.currentItem = 0
                                self.totalItem = 0
                                self.videoCheck()
                            }
                        }
                    })
                    
                }else if (asset != nil &&  asset!.isKindOfClass(AVComposition.classForCoder()) ){
                    
                    self.currentItem += 1
                    self.slowMotionVideoCount += 1
                    print("in slow video cur item = \(self.currentItem)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if self.currentItem == self.totalItem{
                            
                            if (self.isCalledVideoCheck == false){
                                self.isCalledVideoCheck = true
                                self.currentItem = 0
                                self.totalItem = 0
                                self.videoCheck()
                            }
                            
                            
                        }
                        
                    })
                    
                }
                
            })
            
        }
        
    }
    
    
    func videoCheck() {
        
        
        if self.slowMotionVideoCount > 1 {
            
            showAlertViewWithMessage("Note", message: "You can not zip more than 1 slow motion video at a time.")
            
        }else{
            
            showEnterNameAlert("Video-"+Timestamp,assets: selectVideo, type: fileTypeVideo)
            
        }
        
    }
    
    
    
    func getSlowMotionVideo(asset:AVAsset , filePath:String, cacheDir:String , totalItem:Int, currentItem:Int) -> Void {
        
        objc_sync_enter(self)
        
        let fileUrl = NSURL(fileURLWithPath: filePath)
        
        let exporter = AVAssetExportSession(asset: asset, presetName:AVAssetExportPresetHighestQuality)
        exporter?.outputURL = fileUrl
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        exporter?.shouldOptimizeForNetworkUse = true
        
        objc_sync_exit(self)
        
        exporter?.exportAsynchronouslyWithCompletionHandler({ () -> Void in
            
            objc_sync_enter(self)
            
            if exporter?.status == AVAssetExportSessionStatus.Completed{
                
                objc_sync_exit(self)
                print(exporter?.outputURL)
                NSNotificationCenter.defaultCenter().postNotificationName("check_slow_video", object: nil)
                
                
            }else{
                
                print("Error occured while generating video zip")
                objc_sync_exit(self)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    SwiftSpinner.hide()
                    
                })
            }
            
            
        })
        
    }
    
    
    func updateVideoStatus() {
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
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
    
    
    func zipMyFiles(newZipFile:String, existingFolder:String) {
        
        
        if !CommonFunctions.sharedInstance.canCreateZip(existingFolder) {
            
            //            try! kFileManager.removeItemAtPath(existingFolder)
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "You do not have enough space to create zip file", vc: self)
            return
        }
        
        
        let success = SSZipArchive.createZipFileAtPath(newZipFile, withContentsOfDirectory: existingFolder)
        if success {
            
            //            try! kFileManager.removeItemAtPath(existingFolder)
            print("Zip file created successfully")
            handleLocalFile()
            self.shareMyFile(newZipFile)
            
            
            
            /*let vc:UnZipVC = UIStoryboard.unZipVC()!
             vc.zipFilePath = newZipFile
             self.navigationController?.pushViewController(vc, animated: true)*/
            
        }
        
    }
    
    func shareMyFile(zipPath:String) -> Void {
        
        let fileDAta = NSURL(fileURLWithPath: zipPath)
        
        let ac = UIActivityViewController(activityItems: [fileDAta,"hello"] , applicationActivities: nil)
        ac.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]
        ac.setValue("My file", forKey: "Subject")
        
        
        if let popoverPresentationController = ac.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            var rect=self.view.frame
            rect.origin.y = rect.height
            popoverPresentationController.sourceRect = rect
        }
        
        
        self.presentViewController(ac, animated: true, completion: nil)
        
    }
    
    func deleteAllFilesInDirectory(directoryPath:String) -> Void {
        
        if let enumerator = kFileManager.enumeratorAtPath(directoryPath) {
            while let fileName = enumerator.nextObject() as? String {
                do {
                    try kFileManager.removeItemAtPath("\(directoryPath)\(fileName)")
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

extension HomeVCNew{
    
    @IBAction func btnMyFilesTapped(sender: AnyObject) {
        if showFullPageAd() {
        }else{
            handleLocalFile()
        }
    }
    
    @IBAction func btnPhotosTapped(sender: AnyObject) {
        if showFullPageAd() {
        }else{
            selectPhotos()
        }
    }
    
    @IBAction func btnVideoTapped(sender: AnyObject) {
        if showFullPageAd() {
        }else{
            selectVideos()
        }
    }
    
    @IBAction func btnMusicTapped(sender: AnyObject) {
        if showFullPageAd() {
        }else{
            selectAudio()
        }
    }
    
    @IBAction func btnDropboxTapped(sender: AnyObject) {
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        if showFullPageAd() {
        }else{
            useDropBox()
        }
    }
    
    @IBAction func btnGoogleDriveTapped(sender: AnyObject) {
        
        guard Reachability.isConnectedToNetwork()else{
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
            return
        }
        if showFullPageAd() {
        }else{
            useGoogle()
        }
    }
    
    @IBAction func btnMoreCloudTapped(sender: AnyObject) {
        
        if showFullPageAd() {
            
        }else{
            
            let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.text"], inMode: .Import)
            importMenu.delegate = self
            self.presentViewController(importMenu, animated: true, completion: nil)
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data", "public.text"], inMode: .Import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            self.presentViewController(documentPicker, animated: true, completion: nil)
        }
        
        
        
    }
    
    
}


extension HomeVCNew : MPMediaPickerControllerDelegate {
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
        print("did pick")
        getSongsAdvance(mediaItemCollection)
        self.dismissViewControllerAnimated(true, completion: nil)
        return
        
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        print("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getSongsAdvance(mediaItemCollection: MPMediaItemCollection) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaItemCollection.items.count > 0 {
            
            showEnterNameAlert("Songs-"+Timestamp,assets: mediaItemCollection.items, type: fileTypeSong)
            
        }else{
            
            print("Song not selected")
            
        }
    }
    
    
    func zipAndShareSongs(items: [AnyObject]!, folderName:String){
        
        var cacheDir = CommonFunctions.sharedInstance.docDirPath()
        cacheDir += "/\(folderName)"
        
        do{
            try kFileManager.createDirectoryAtPath(cacheDir, withIntermediateDirectories: false, attributes: nil)
        }catch let e as NSError{
            print(e)
        }
        
        for item in items as! [MPMediaItem]!{
            
            if item ==  (items as! [MPMediaItem]!).last{
                isLastIndex = true
            }
            
            if item ==  (items as! [MPMediaItem]!).first{
                SwiftSpinner.show("Processing, please wait..")
                currentFile = 0
                totalfileCount = (items as! [MPMediaItem]!).count
            }
            
            print(item.assetURL)
            let filePath = "\(cacheDir)/\(item.title!).m4a"
            let myFileUrl = NSURL(fileURLWithPath: filePath)
            saveAssetUrlToMp3(item.assetURL!, path: myFileUrl, title: item.title!, parentDir: cacheDir)
            
        }
        
    }
    
    func saveAssetUrlToMp3(assetUrl:NSURL, path:NSURL, title:String, parentDir:String) {
        
        let songAsset = AVURLAsset(URL: assetUrl, options: nil)
        let exporter = AVAssetExportSession(asset: songAsset, presetName: AVAssetExportPresetPassthrough)
        exporter!.outputFileType = "com.apple.quicktime-movie";
        exporter?.outputURL = path
        exporter?.shouldOptimizeForNetworkUse = true
        
        exporter?.exportAsynchronouslyWithCompletionHandler( { () -> Void in
            
            if(exporter?.status == AVAssetExportSessionStatus.Completed){
                
                let filePath = "\(parentDir)/\(title).m4a"
                var fileSize : UInt64 = 0
                do {
                    let attr : NSDictionary? = try kFileManager.attributesOfItemAtPath(filePath)
                    if let _attr = attr {
                        fileSize = _attr.fileSize();
                        print("fileSize: \(fileSize)")
                    }
                    var newFilePath = ""
                    if title.containsString(".mp3"){
                        newFilePath = filePath.stringByReplacingOccurrencesOfString(".m4a", withString: "")
                    }else{
                        newFilePath = filePath.stringByReplacingOccurrencesOfString(".m4a", withString: ".mp3")
                    }
                    try! kFileManager.moveItemAtPath(filePath, toPath: newFilePath)
                    
                } catch {
                    print("Error: \(error)")
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.currentFile += 1
                    if self.currentFile == self.totalfileCount {
                        SwiftSpinner.hide()
                    }
                    
                })
                
            }
        })
    }
    
    
    
}

extension  HomeVCNew:UIDocumentPickerDelegate,UIDocumentMenuDelegate{
    
    
    
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        print(url.path!)
        let zipPath = "\(CommonFunctions.sharedInstance.docDirPath())/\((url.lastPathComponent)!).zip"
        CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: url.path!, vc: self)
        self.performSelector(#selector(HomeVCNew.handleLocalFile), withObject: nil, afterDelay: 1)
        
    }
    
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate=self
        self.presentViewController(documentPicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func pickerButtonPressed(sender1: UIButton) {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.text"], inMode: .Import)
        
        importMenu.delegate = self
        
        self.presentViewController(importMenu, animated: true, completion: nil)
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data", "public.text"], inMode: .Import)
        
        documentPicker.delegate = self
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        self.presentViewController(documentPicker, animated: true, completion: nil)
        
    }
    
    func showEnterNameAlert(name:String ,assets: [AnyObject]!, type:Int){
        
        let alertController = UIAlertController(title: "Wait", message: "Please enter zip name", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if(firstTextField.text?.length == 0){
                
                self.showAlert("Please enter folder name", assets: assets, type: type)
                return
            }
            
            if(firstTextField.text?.isValidName() == false){
                
                self.showAlert("Special characters are not allowed", assets: assets, type: type)
                return
            }
            
            
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(firstTextField.text!)"
            
            if(kFileManager.fileExistsAtPath(cacheDir)){
                
                self.showAlert("Folder or file already exists, please provide new name", assets: assets, type: type)
                
            }else{
                
                
                
                if(type == fileTypeImage){
                    
                    
                    //                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.zipAndShareImages(assets, folderName: firstTextField.text!)
                    
                    
                }else if(type == fileTypeVideo){
                    
                    self.zipAndShareVideos(assets, folderName: firstTextField.text!)
                    
                }else if(type == fileTypeSong){
                    
                    self.zipAndShareSongs(assets, folderName: firstTextField.text!)
                    
                }else{
                    
                }
                
                
                
            }
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.text = name
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(name:String ,assets: [AnyObject]!, type:Int){
        
        let alertController = UIAlertController(title: "Wait", message: name, preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            
            var archiveName = ""
            
            if(type == fileTypeImage){
                
                archiveName = "Image-"+Timestamp
                
            }else if(type == fileTypeVideo){
                
                archiveName = "Video-"+Timestamp
                
            }else if(type == fileTypeSong){
                
                archiveName = "Song-"+Timestamp
                
            }else{
                
                archiveName = "Document-"+Timestamp
            }
            
            self.showEnterNameAlert(archiveName ,assets: assets, type: type)
            
            
            
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}

