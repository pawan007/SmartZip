//
//  CommonFunctions.swift
//  WorklifeCALENDAR
//
//  Copyright © 2016 WorklifeCALENDAR. All rights reserved.

import Foundation
import UIKit
import SSZipArchive

class CommonFunctions: NSObject {
    
    private static var __once: () = {
            Static.instance = CommonFunctions()
        }()
    
    /// Singleton object
    class var sharedInstance : CommonFunctions {
        struct Static {
            static var onceToken : Int = 0
            static var instance : CommonFunctions? = nil
        }
        _ = CommonFunctions.__once
        return Static.instance!
    }
    
    //MARK: NSUser Defaults
    //---------------------------------------------
    // Saving and Getting data from User Defaults
    //---------------------------------------------
    func setStringToUserDefaults(_ strValueToSave:String, key:String) -> Void {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(strValueToSave, forKey: key)
        userDefaults.synchronize()
    }
    
    
    func getStringFromUserDefaults(_ key:String) -> String {
        let userDefaults: UserDefaults = UserDefaults.standard
        let strValue: String? = userDefaults.object(forKey: key) as? String
        if(strValue == nil){
            return ""
        }else{
            return strValue!
        }
    }
    
    func setBOOLToUserDefaults(_ boolValue:Bool, key:String) -> Void {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(boolValue, forKey: key)
        userDefaults.synchronize()
    }
    
    func getBOOLFromUserDefaults(_ key:String) -> Bool {
        let userDefaults: UserDefaults = UserDefaults.standard
        let boolValue: Bool? = userDefaults.bool(forKey: key)
        return boolValue!
    }
    
    func setDictionaryToUserDefaults(_ dict:NSMutableDictionary, key:String) -> Void {
        let userDefaults: UserDefaults = UserDefaults.standard
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: dict)
        userDefaults.set(data, forKey: key)
        userDefaults.synchronize()
    }
    
    func getDictionaryFromUserDefaults(_ key:String) -> NSMutableDictionary {
        let userDefaults: UserDefaults = UserDefaults.standard
        let data: Data = userDefaults.object(forKey: key) as! Data
        let dictData: NSMutableDictionary? = ((NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject).mutableCopy())! as? NSMutableDictionary
        return dictData!
    }
    
    //---------------------------------------------
    // Checking for Null
    //---------------------------------------------
    func checkForNull(_ valueToCheck:String?) -> String {
        var checkedString: String? = valueToCheck
        
        if (valueToCheck == nil) {
            checkedString = ""
        }
        else {
            checkedString = valueToCheck!
        }
        
        if ( checkedString?.range(of: "null") != nil ) {//exists
            checkedString = ""
        }
        if ( checkedString?.range(of: "<null>") != nil ) {//exists
            checkedString = ""
        }
        return checkedString!
    }
    
    /**
     *  validating the email address
     */
    func enteredEmailAddressIsValid(_ strEmail: String) -> Bool {
        
        //        let stricterFilter: Bool = false
        let stricterFilterString: String = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        //        let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        //        let emailRegex: String = stricterFilter ? stricterFilterString : laxString;
        let emailRegex: String = stricterFilterString
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES \(emailRegex)", argumentArray: nil)
        
        return emailTest.evaluate(with: strEmail)
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /**
     *  validating the URL
     */
    func validateUrl(_ strUrl: String) -> Bool {
        let urlRegEx: String = "((https|http)://)?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES \(urlRegEx)", argumentArray: nil)
        return urlTest.evaluate(with: strUrl)
    }
    
    /**
     *  Trim string
     */
    func trim(_ textToTrim:String)->String{
        
        return textToTrim.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /**
     * @method imageToNSString
     *  @param image pass your image here
     *  @return a string
     */
    func imageToNSString(_ image: UIImage) -> String {
        
        let imageData: Data = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    }
    
    /**
     *  Getting Name of Storyboards
     */
    func getMainStoryBoard() -> UIStoryboard {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard;
    }
    /**
     *  Getting Name of Storyboards
     */
    func getSettingsStoryBoard() -> UIStoryboard {
        let storyboard: UIStoryboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        return storyboard;
    }
    
    /**
     *  Getting Name of Storyboards
     */
    func getNotificationStoryBoard() -> UIStoryboard {
        let storyboard: UIStoryboard = UIStoryboard(name: "Notification", bundle: nil)
        return storyboard;
    }
    
    
    //----For UTC Date
    func getUTCCurrentDateAndTime() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    //----Get Date in UTC from Date
    func getUTCDateFromDate(_ strDateToModify: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let dateToModify = dateFormatter.date(from: strDateToModify)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: dateToModify!)
    }
    
    //---------------------------------------------
    // Get date in current time zone from UTC Date
    //---------------------------------------------
    func dateInCurrentTimeZoneFromUTC(_ dateInUtc: Date) -> Date {
        let currentTimeZone: TimeZone = TimeZone.autoupdatingCurrent
        let utcTimeZone: TimeZone = TimeZone(abbreviation: "UTC")!
        
        let currentGMTOffset: NSInteger = currentTimeZone.secondsFromGMT(for: dateInUtc)
        let gmtOffset: NSInteger = utcTimeZone.secondsFromGMT(for: dateInUtc)
        let gmtInterval: TimeInterval = Double((currentGMTOffset - gmtOffset))
        
        return Date(timeInterval: gmtInterval, since: dateInUtc)
    }
    
    /**
     *  Changing the color of string
     */
    func textAfterChangingColorAndFont(_ strTextToModify: String, strFullText: String) -> NSAttributedString {
        let strToMakeBold: String = strTextToModify
        let hintText : NSMutableAttributedString = NSMutableAttributedString(string: strFullText)
        let range: NSRange = (strFullText as NSString).range(of: strToMakeBold)
        
        hintText.setAttributes([NSForegroundColorAttributeName:UIColor(red: 0/255.0, green: 161/255.0, blue: 184/255.0, alpha: 1.0), NSFontAttributeName:UIFont(name:"", size: 16.0)!], range:range)
        return hintText;
    }
    
    func addSpaceBetweenLinesOfLabel(_ lbl: UILabel, strText: NSString, space: CGFloat) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (strText as String))
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        
        let range: NSRange = strText.range(of: strText as String)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        lbl.attributedText = attributedString
    }
    
    
    /*
     Scroll to positon in scrollview
     */
    func scrollToPositionIn(_ scrllView:UIScrollView, ViewToShow:AnyObject, animated: Bool) {
        let scrollPoint : CGPoint = CGPoint(x: 0, y: ViewToShow.frame.origin.y - ViewToShow.frame.size.height)
        scrllView.setContentOffset(scrollPoint, animated: animated)
    }
    
    
    /*
     Get Screen Shot for current screen
     */
    func getCurrentScreenShot() -> UIImage {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
    
    
    func scheduleLocalNotification(_ alertBody:String,fireDate:String,userInfoDict:NSMutableDictionary) {
        let settings = UIApplication.shared.currentUserNotificationSettings
        
        if settings!.types == UIUserNotificationType() {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        let alarmTime = dateFormatter.date(from: fireDate)
        
        let notification = UILocalNotification()
        notification.fireDate = alarmTime
        notification.alertBody = alertBody
        notification.alertAction = "Open app!"
        notification.soundName = "Alarm.mp3"
        notification.category = ""
        notification.userInfo = userInfoDict as! [AnyHashable: Any]
        print("alarm for shift = \(notification)")
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    func getFormattedTimeFromNSDate(_ date:Date)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getSimpleDate(_ date:Date)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getAmPmDateFromDate(_ date:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func getSimpleDateForOverrideRoster(_ date:Date)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getNSDateFromString(_ strDate:String)->Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        return dateFormatter.date(from: strDate)!
    }
    
    func getTodaysDate(_ format:String)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: Date())
        return strDate
    }
    
    func getTitleDate(_ date:Date, format:String)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func getFormattedTimeFromString(_ dateString:String)->String{
        
        print(dateString)
        let fullNameArr = dateString.components(separatedBy: " ")
        print(fullNameArr)
        
        if(fullNameArr[1] == "00:00:00"){
            return "06:00"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: fullNameArr[1])
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        let strDate = dateFormatter1.string(from: date!)
        return strDate
    }
    
    
    func getFormattedTimeFromStringAMPM(_ dateString:String)->String{
        
        print(dateString)
        let fullNameArr = dateString.components(separatedBy: " ")
        print(fullNameArr)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: fullNameArr[1])
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        dateFormatter1.amSymbol = "am"
        dateFormatter1.pmSymbol = "pm"
        let strDate = dateFormatter1.string(from: date!)
        return strDate
    }
    
    func getFormattedTimeFromStringAMPMNew(_ dateString:String)->String{
        
        print(dateString)
        let fullNameArr = dateString.components(separatedBy: " ")
        print(fullNameArr)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a"
        let strDate = dateFormatter1.string(from: date!)
        return strDate
    }
    
    func getRosterDayFormattedDate(_ dateString:String)->String{
        
        print(dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateString)
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "EEE. dd MMM. yyyy"
        let strDate = dateFormatter1.string(from: date!)
        return strDate
    }
    
    
    func zipMyFiles(_ newZipFile:String, filePath:String , vc:UIViewController) {
        
        if !CommonFunctions.sharedInstance.canCreateZip(filePath) {
            
            try! kFileManager.removeItem(atPath: filePath)
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "You do not have enough space to create zip file", vc: vc)
            return
        }
        
        
        let success = SSZipArchive.createZipFileAtPath(newZipFile, withFilesAtPaths: [filePath])
        if success {
            try! kFileManager.removeItem(atPath: filePath)
            print("Zip file created successfully")
            self.shareMyFile(newZipFile, vc: vc)
        }
        
    }
    
    
    func zipAllMyFiles(_ newZipFile:String , vc:UIViewController, files : [FBFile]) -> Bool {
        
        var arrayPaths = [String]()
        for item in files {
            arrayPaths.append(item.filePath.path!)
        }
        
        do{
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/test\(Timestamp)"
            
            do{
                try kFileManager.createDirectory(atPath: cacheDir, withIntermediateDirectories: false, attributes: nil)
            }catch let e as NSError{
                print(e)
            }
            
            for item in arrayPaths {
                
                let newUrl = URL(fileURLWithPath: item)
                let name = item.components(separatedBy: "/").last
                let newPath = cacheDir+"/"+name!
                let newUrlFile = URL(fileURLWithPath: newPath)
                
                do{
                    try kFileManager.copyItem(at: newUrl, to: newUrlFile)
                }catch let e as NSError{
                    print(e)
                }
                
            }
            
            let success = SSZipArchive.createZipFileAtPath(newZipFile, withContentsOfDirectory: cacheDir)
            if success {
                print("Zip file created successfully")
                try! kFileManager.removeItem(atPath: cacheDir)
                self.shareMyFile(newZipFile, vc: vc)
                return true
            }
            
        }catch let error{
            
            print(error)
        }
        
        
        
        /*if !CommonFunctions.sharedInstance.canCreateZip2(arrayPaths) {
         CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "You do not have enough space to create zip file", vc: vc)
         return false
         }*/
        
        
        return false
    }
    
    func shareMyFile(_ zipPath:String, vc:UIViewController) -> Void {
        
        let fileDAta = URL(fileURLWithPath: zipPath)
        
        let ac = UIActivityViewController(activityItems: [fileDAta,"hello"] , applicationActivities: nil)
        ac.excludedActivityTypes = [UIActivityType.print, UIActivityType.copyToPasteboard,UIActivityType.assignToContact, UIActivityType.saveToCameraRoll]
        ac.setValue("My file", forKey: "Subject")
        
        if let popoverPresentationController = ac.popoverPresentationController {
            popoverPresentationController.sourceView = vc.view
            var rect=vc.view.frame
            rect.origin.y = rect.height
            popoverPresentationController.sourceRect = rect
        }
        vc.present(ac, animated: true, completion: nil)
        
    }
    
    
    func docDirPath() -> String {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return directoryPath!
    }
    
    func report_memory() {
        // constant
        let MACH_TASK_BASIC_INFO_COUNT = (MemoryLayout<mach_task_basic_info_data_t>.size / MemoryLayout<natural_t>.size)
        
        // prepare parameters
        let name   = mach_task_self_
        let flavor = task_flavor_t(MACH_TASK_BASIC_INFO)
        var size   = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)
        
        // allocate pointer to mach_task_basic_info
        let infoPointer = UnsafeMutablePointer<mach_task_basic_info>.allocate(capacity: 1)
        
        // call task_info - note extra UnsafeMutablePointer(...) call
        let kerr = task_info(name, flavor, UnsafeMutablePointer(infoPointer), &size)
        
        // get mach_task_basic_info struct out of pointer
        let info = infoPointer.move()
        
        // deallocate pointer
        infoPointer.deallocate(capacity: 1)
        
        // check return value for success / failure
        if kerr == KERN_SUCCESS {
            print("Memory in use (in MB): \(info.resident_size/1000000)")
            print("Memory in use (in MB): \(info.resident_size_max/1000000)")
            
            let remSize = ( info.resident_size_max - info.resident_size ) / 1000000
            print("Free Memory): \(remSize)")
            
            
        } else {
            let errorString = String(CString: mach_error_string(kerr), encoding: String.Encoding.ascii)
            print(errorString ?? "Error: couldn't parse error string")
        }    
    }
    
    
    /*-(uint64_t)getFreeDiskspace {
     uint64_t totalSpace = 0;
     uint64_t totalFreeSpace = 0;
     NSError *error = nil;
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
     
     if (dictionary) {
     NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
     NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
     totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
     totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
     NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
     } else {
     NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
     }
     
     return totalFreeSpace;
     }*/
    
    func getFreeDiscSpase() -> UInt64 {
        
        var totalSpace:CUnsignedLongLong = 0
        var totalFreeSpace:CUnsignedLongLong = 0
        //        var error:NSError?
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        do{
            
            let dictionary = try kFileManager.attributesOfFileSystem(forPath: paths.last!)
            
            if !dictionary.isEmpty {
                let fileSystemSizeInBytes = dictionary[FileAttributeKey.systemSize]
                let freeFileSystemSizeInBytes = dictionary[FileAttributeKey.systemFreeSize]
                totalSpace = (fileSystemSizeInBytes?.uint64Value)!
                totalFreeSpace = (freeFileSystemSizeInBytes?.uint64Value)!
                print("Memory Capacity of \( ((totalSpace/1024)/1024) ) MiB with \( ((totalFreeSpace/1024)/1024) ) MiB Free memory available.")
            }
            return totalFreeSpace
            
        }catch let error{
            
            print(error)
            return totalFreeSpace
            
        }
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
    
    func getFolderSize(_ directoryPath:String) -> CUnsignedLongLong {
        
        var totalFolderSize:CUnsignedLongLong = 0
        
        if fileIsDir(directoryPath) {
            
            if let enumerator = kFileManager.enumerator(atPath: directoryPath) {
                while let fileName = enumerator.nextObject() as? String {
                    
                    totalFolderSize += getFileSize("\(directoryPath)/\(fileName)")
                    
                }
            }
            
        }else{
            
            totalFolderSize = getFileSize(directoryPath)
            
        }
        
        
        return totalFolderSize
    }
    
    func getFileSize(_ filePath:String) -> CUnsignedLongLong {
        
        var fileSize:CUnsignedLongLong = 0
        
        if fileIsDir(filePath) {
            
            return getFolderSize(filePath)
            
        }else{
            
            do{
                //                var fileSize : UInt64 = 0
                let attr:NSDictionary? = try kFileManager.attributesOfItem(atPath: filePath)
                if let _attr = attr {
                    fileSize = _attr.fileSize();
                    return fileSize
                    
                }else {
                    
                    return fileSize
                }
                
                /*let dictionary = try kFileManager.attribute(kFileManager)
                 
                 if !dictionary.isEmpty {
                 
                 let fileSizeInBytes = dictionary[NSFileSize]
                 fileSize = (fileSizeInBytes?.unsignedLongLongValue)!
                 return fileSize
                 
                 }else{
                 
                 return fileSize
                 }*/
                
            }catch let error{
                
                print(error)
                return fileSize
                
            }
            
        }
        
    }
    
    
    func fileIsDir(_ path: String) -> Bool {
        var isDir: ObjCBool = false;
        kFileManager.fileExists(atPath: path, isDirectory: &isDir)
        return Bool(isDir);
    }
    
    func canCreateZip(_ path: String) -> Bool {
        
        let freeSpace = getFreeDiscSpase()
        let fileSpace = getFolderSize(path)
        let difference = freeSpace - fileSpace
        if difference > 0 {
            return true
        }
        return false
    }
    
    func canCreateZip2(_ path: [String]) -> Bool {
        
        let freeSpace = getFreeDiscSpase()
        var fileSpace:CUnsignedLongLong = 0
        
        for item in path {
            fileSpace += getFolderSize(item)
        }
        
        fileSpace += fileSpace
        
        let difference = freeSpace - fileSpace
        if difference > 0 {
            return true
        }
        return false
    }
    
    
    // Helper for showing an alert
    func showAlert(_ title : String, message: String, vc:UIViewController) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    
    
}


extension String{
    
    func isValidName () -> Bool {
        
        let emailFormat = "^[a-zA-Z0-9_-]{1,100}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
}
