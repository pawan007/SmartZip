//
//  HomeVC.swift
//  SmartZip
//
//  Created by Pawan Kumar on 26/06/16.
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


let fileTypeImage = 1
let fileTypeVideo = 2
let fileTypeSong = 3


class HomeVC: UITableViewController, QBImagePickerControllerDelegate {
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoPickerVC.updateVideoStatus), name: NSNotification.Name(rawValue: "check_slow_video"), object: nil)
        
        if APPDELEGATE.isOpenedFromExternalResource {
            isOpenedFromExternalResource = true
        }
        
        if(!CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            //GADBannerView
            // self.setUpGoogleAds()
            shared = GADMasterViewController.singleton()
            shared.resetAdView(self, andDisplayView: _bView)
        }
        
        //        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "Ic_Back"), style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isOpenedFromExternalResource {
            isOpenedFromExternalResource = false
            self.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
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
        
        if (CommonFunctions.sharedInstance.getBOOLFromUserDefaults(kIsRemovedBannerAds)) {
            if(shared != nil) {
                shared = nil
            }
            _bView.isHidden = true
        }
        
        // self.setUpGoogleAds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
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
    
    func animation(_ animationView:UIView) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            DispatchQueue.main.async {
                let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
                animation.fromValue = 0;
                animation.toValue = 2 * M_PI;
                animation.repeatCount = 1;//INFINITY;
                animation.duration = 0.5;
                animationView.layer.add(animation, forKey: "rotation")
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
        if  UserDefaults.standard.object(forKey: str) != nil {
            var val = (UserDefaults.standard.object(forKey: str)? as AnyObject).intValue
            val = val! - 1
            if(val == 0) {
                isShow = true
                let number = self.randomInt(1, max: 4)
                UserDefaults.setObject(number, forKey: str)
            }
            else {
                UserDefaults.setObject(val, forKey: str)
            }
            
        }
        else {
            let number = self.randomInt(1, max: 4)
            UserDefaults.setObject(number, forKey: str)
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
    
    func randomInt(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
                
                
                let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.text"], in: .import)
                
                importMenu.delegate = self
                
                self.present(importMenu, animated: true, completion: nil)
                
                let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data", "public.text"], in: .import)
                
                documentPicker.delegate = self
                
                documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                
                self.present(documentPicker, animated: true, completion: nil)
                
                
                /*guard Reachability.isConnectedToNetwork()else{
                 CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
                 return
                 }
                 useMoreCloud()*/
            }
            
        }
        
        
        
    }
    @IBAction   func menuButtonAction(_ sender: AnyObject) {
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
        let fileListViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FileListViewController")
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
        
        let picker = MPMediaPickerController(mediaTypes:.music)
        picker.showsCloudItems = false
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        picker.modalPresentationStyle = .popover
        picker.preferredContentSize = CGSize(width: 500,height: 600)
        self.present(picker, animated: true, completion: nil)
        
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
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        
        flagVideo = false
        flagImage = false
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        
        
        
        
        if flagImage {
            
            /*for item in assets{
             
             let asset = item as! PHAsset
             
             asset.requestContentEditingInputWithOptions(PHContentEditingInputRequestOptions()) { (input, _) in
             let url = input!.fullSizeImageURL
             print(url)
             }
             }*/
            
            self.dismiss(animated: true, completion: nil)
            showEnterNameAlert("Images-"+Timestamp,assets: assets, type: fileTypeImage)
            //            
            //            self.dismissViewControllerAnimated(true, completion: nil)
            //            zipAndShareImages(assets)
            
        }else{
            
            
            self.dismiss(animated: true, completion: nil)
            selectVideo = assets
            canCreateVideo(selectVideo)
            
        }
        
        flagVideo = false
        flagImage = false
    }
    
    
    
    func zipAndShareImages(_ assets: [AnyObject]!, folderName:String) {
        
        //        var folderName = ""
        
        if assets.count > 0 {
            
            SwiftSpinner.show("Processing, please wait..")
            //            deleteAllFilesInDirectory(NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])
            
            //            folderName = "Images-\(Timestamp)"
            //            var cacheDir = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(folderName)"
            
            do{
                try kFileManager.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
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
    
    func zipAndShareVideos(_ assets: [AnyObject]!, folderName:String) {
        
        //        var folderName = ""
        
        if assets.count > 0 {
            
            
            
            SwiftSpinner.show("Processing, please wait..")
            
            
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/\(folderName)"
            
            do{
                try kFileManager.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
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
    
    
    
    
    func canCreateVideo(_ assets: [AnyObject]!){
        
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
    
    
    func zipMyFiles(_ newZipFile:String, existingFolder:String) {
        
        
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
    
    func shareMyFile(_ zipPath:String) -> Void {
        
        let fileDAta = URL(fileURLWithPath: zipPath)
        
        let ac = UIActivityViewController(activityItems: [fileDAta,"hello"] , applicationActivities: nil)
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
        
        if let enumerator = kFileManager.enumerator(atPath: directoryPath) {
            while let fileName = enumerator.nextObject() as? String {
                do {
                    try kFileManager.removeItem(atPath: "\(directoryPath)\(fileName)")
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

extension HomeVC {
    
    @IBAction func btnMyFilesTapped(_ sender: AnyObject) {
        if (self.showFullPageAd()) {
            return;
        }
        else {
            handleLocalFile()
        }
    }
    
    @IBAction func btnPhotosTapped(_ sender: AnyObject) {
        if (self.showFullPageAd()) {
            return;
        }
        else {
            selectPhotos()
        }
    }
    
    @IBAction func btnVideoTapped(_ sender: AnyObject) {
        if (self.showFullPageAd()) {
            return;
        }
        else {
            selectVideos()
        }
    }
    
    @IBAction func btnMusicTapped(_ sender: AnyObject) {
        if (self.showFullPageAd()) {
            return;
        }
        else {
            selectAudio()
        }
    }
    
    @IBAction func btnDropboxTapped(_ sender: AnyObject) {
        
        if (self.showFullPageAd()) {
            return;
        }
        else {
            guard Reachability.isConnectedToNetwork()else{
                CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
                return
            }
            useDropBox()
        }
    }
    
    @IBAction func btnGoogleDriveTapped(_ sender: AnyObject) {
        if (self.showFullPageAd()) {
            return;
        }
        else {
            guard Reachability.isConnectedToNetwork()else{
                CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "Please connect to internet", vc: self)
                return
            }
            useGoogle()
        }
    }
    
    @IBAction func btnMoreCloudTapped(_ sender: AnyObject) {
        if (self.showFullPageAd()) {
            return;
        }
        else {
            let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.text"], in: .import)
            importMenu.delegate = self
            self.present(importMenu, animated: true, completion: nil)
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data", "public.text"], in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(documentPicker, animated: true, completion: nil)
        }
        
    }
    
    
}


extension HomeVC : MPMediaPickerControllerDelegate {
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
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaItemCollection.items.count > 0 {
            
            showEnterNameAlert("Songs-"+Timestamp,assets: mediaItemCollection.items, type: fileTypeSong)
            
        }else{
            
            print("Song not selected")
            
        }
    }
    
    
    func zipAndShareSongs(_ items: [AnyObject]!, folderName:String){
        
        var cacheDir = CommonFunctions.sharedInstance.docDirPath()
        cacheDir += "/\(folderName)"
        
        do{
            try kFileManager.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
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
            let myFileUrl = URL(fileURLWithPath: filePath)
            saveAssetUrlToMp3(item.assetURL!, path: myFileUrl, title: item.title!, parentDir: cacheDir)
            
        }
        
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
                    let attr : NSDictionary? = try kFileManager.attributesOfItem(atPath: filePath)
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
                    try! kFileManager.moveItem(atPath: filePath, toPath: newFilePath)
                    
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

extension  HomeVC:UIDocumentPickerDelegate,UIDocumentMenuDelegate{
    
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        print(url.path)
        let zipPath = "\(CommonFunctions.sharedInstance.docDirPath())/\((url.lastPathComponent)).zip"
        CommonFunctions.sharedInstance.zipMyFiles(zipPath, filePath: url.path!, vc: self)
        self.perform(#selector(HomeVC.handleLocalFile), with: nil, afterDelay: 1)
        
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate=self
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func pickerButtonPressed(_ sender1: UIButton) {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.data", "public.text"], in: .import)
        
        importMenu.delegate = self
        
        self.present(importMenu, animated: true, completion: nil)
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data", "public.text"], in: .import)
        
        documentPicker.delegate = self
        
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    func showEnterNameAlert(_ name:String ,assets: [AnyObject]!, type:Int){
        
        let alertController = UIAlertController(title: "Wait", message: "Please enter zip name", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
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
            
            if(kFileManager.fileExists(atPath: cacheDir)){
                
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.text = name
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(_ name:String ,assets: [AnyObject]!, type:Int){
        
        let alertController = UIAlertController(title: "Wait", message: name, preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
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
        
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

