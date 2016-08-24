//
//  CommonFunctions.swift
//  WorklifeCALENDAR
//
//  Copyright © 2016 WorklifeCALENDAR. All rights reserved.

import Foundation
import UIKit
import SSZipArchive

class CommonFunctions: NSObject {
    
    /// Singleton object
    class var sharedInstance : CommonFunctions {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CommonFunctions? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = CommonFunctions()
        }
        return Static.instance!
    }
    
    //MARK: NSUser Defaults
    //---------------------------------------------
    // Saving and Getting data from User Defaults
    //---------------------------------------------
    func setStringToUserDefaults(strValueToSave:String, key:String) -> Void {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(strValueToSave, forKey: key)
        userDefaults.synchronize()
    }
    
    
    func getStringFromUserDefaults(key:String) -> String {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let strValue: String? = userDefaults.objectForKey(key) as? String
        if(strValue == nil){
            return ""
        }else{
            return strValue!
        }
    }
    
    func setBOOLToUserDefaults(boolValue:Bool, key:String) -> Void {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(boolValue, forKey: key)
        userDefaults.synchronize()
    }
    
    func getBOOLFromUserDefaults(key:String) -> Bool {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let boolValue: Bool? = userDefaults.boolForKey(key)
        return boolValue!
    }
    
    func setDictionaryToUserDefaults(dict:NSMutableDictionary, key:String) -> Void {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(dict)
        userDefaults.setObject(data, forKey: key)
        userDefaults.synchronize()
    }
    
    func getDictionaryFromUserDefaults(key:String) -> NSMutableDictionary {
        let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let data: NSData = userDefaults.objectForKey(key) as! NSData
        let dictData: NSMutableDictionary? = (NSKeyedUnarchiver.unarchiveObjectWithData(data)?.mutableCopy())! as? NSMutableDictionary
        return dictData!
    }
    
    //---------------------------------------------
    // Checking for Null
    //---------------------------------------------
    func checkForNull(valueToCheck:String?) -> String {
        var checkedString: String? = valueToCheck
        
        if (valueToCheck == nil) {
            checkedString = ""
        }
        else {
            checkedString = valueToCheck!
        }
        
        if ( checkedString?.rangeOfString("null") != nil ) {//exists
            checkedString = ""
        }
        if ( checkedString?.rangeOfString("<null>") != nil ) {//exists
            checkedString = ""
        }
        return checkedString!
    }
    
    /**
     *  validating the email address
     */
    func enteredEmailAddressIsValid(strEmail: String) -> Bool {
        
        //        let stricterFilter: Bool = false
        let stricterFilterString: String = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        //        let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        //        let emailRegex: String = stricterFilter ? stricterFilterString : laxString;
        let emailRegex: String = stricterFilterString
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES \(emailRegex)", argumentArray: nil)
        
        return emailTest.evaluateWithObject(strEmail)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    /**
     *  validating the URL
     */
    func validateUrl(strUrl: String) -> Bool {
        let urlRegEx: String = "((https|http)://)?((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let urlTest: NSPredicate = NSPredicate(format: "SELF MATCHES \(urlRegEx)", argumentArray: nil)
        return urlTest.evaluateWithObject(strUrl)
    }
    
    /**
     *  Trim string
     */
    func trim(textToTrim:String)->String{
        
        return textToTrim.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    /**
     * @method imageToNSString
     *  @param image pass your image here
     *  @return a string
     */
    func imageToNSString(image: UIImage) -> String {
        
        let imageData: NSData = UIImagePNGRepresentation(image)!
        return imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
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
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(NSDate())
    }
    
    //----Get Date in UTC from Date
    func getUTCDateFromDate(strDateToModify: String) -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        let dateToModify = dateFormatter.dateFromString(strDateToModify)
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.stringFromDate(dateToModify!)
    }
    
    //---------------------------------------------
    // Get date in current time zone from UTC Date
    //---------------------------------------------
    func dateInCurrentTimeZoneFromUTC(dateInUtc: NSDate) -> NSDate {
        let currentTimeZone: NSTimeZone = NSTimeZone.localTimeZone()
        let utcTimeZone: NSTimeZone = NSTimeZone(abbreviation: "UTC")!
        
        let currentGMTOffset: NSInteger = currentTimeZone.secondsFromGMTForDate(dateInUtc)
        let gmtOffset: NSInteger = utcTimeZone.secondsFromGMTForDate(dateInUtc)
        let gmtInterval: NSTimeInterval = Double((currentGMTOffset - gmtOffset))
        
        return NSDate(timeInterval: gmtInterval, sinceDate: dateInUtc)
    }
    
    /**
     *  Changing the color of string
     */
    func textAfterChangingColorAndFont(strTextToModify: String, strFullText: String) -> NSAttributedString {
        let strToMakeBold: String = strTextToModify
        let hintText : NSMutableAttributedString = NSMutableAttributedString(string: strFullText)
        let range: NSRange = (strFullText as NSString).rangeOfString(strToMakeBold)
        
        hintText.setAttributes([NSForegroundColorAttributeName:UIColor(red: 0/255.0, green: 161/255.0, blue: 184/255.0, alpha: 1.0), NSFontAttributeName:UIFont(name:"", size: 16.0)!], range:range)
        return hintText;
    }
    
    func addSpaceBetweenLinesOfLabel(lbl: UILabel, strText: NSString, space: CGFloat) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: (strText as String))
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        
        let range: NSRange = strText.rangeOfString(strText as String)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        lbl.attributedText = attributedString
    }
    
    
    /*
     Scroll to positon in scrollview
     */
    func scrollToPositionIn(scrllView:UIScrollView, ViewToShow:AnyObject, animated: Bool) {
        let scrollPoint : CGPoint = CGPointMake(0, ViewToShow.frame.origin.y - ViewToShow.frame.size.height)
        scrllView.setContentOffset(scrollPoint, animated: animated)
    }
    
    
    /*
     Get Screen Shot for current screen
     */
    func getCurrentScreenShot() -> UIImage {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
    
    func scheduleLocalNotification(alertBody:String,fireDate:String,userInfoDict:NSMutableDictionary) {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        
        if settings!.types == .None {
            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            //presentViewController(ac, animated: true, completion: nil)
            return
        }
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let alarmTime = dateFormatter.dateFromString(fireDate)
        
        let notification = UILocalNotification()
        notification.fireDate = alarmTime
        notification.alertBody = alertBody
        notification.alertAction = "Open app!"
        notification.soundName = "Alarm.mp3"
        notification.category = ""
        notification.userInfo = userInfoDict as [NSObject : AnyObject]
        print("alarm for shift = \(notification)")
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    func getFormattedTimeFromNSDate(date:NSDate)->String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    func getSimpleDate(date:NSDate)->String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    func getAmPmDateFromDate(date:NSDate)->String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.AMSymbol = "am"
        formatter.PMSymbol = "pm"
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    func getSimpleDateForOverrideRoster(date:NSDate)->String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    func getNSDateFromString(strDate:String)->NSDate{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")
        return dateFormatter.dateFromString(strDate)!
    }
    
    func getTodaysDate(format:String)->String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.stringFromDate(NSDate())
        return strDate
    }
    
    func getTitleDate(date:NSDate, format:String)->String{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.stringFromDate(date)
        return strDate
    }
    
    func getFormattedTimeFromString(dateString:String)->String{
        
        print(dateString)
        let fullNameArr = dateString.componentsSeparatedByString(" ")
        print(fullNameArr)
        
        if(fullNameArr[1] == "00:00:00"){
            return "06:00"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.dateFromString(fullNameArr[1])
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "HH:mm"
        let strDate = dateFormatter1.stringFromDate(date!)
        return strDate
    }
    
    
    func getFormattedTimeFromStringAMPM(dateString:String)->String{
        
        print(dateString)
        let fullNameArr = dateString.componentsSeparatedByString(" ")
        print(fullNameArr)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.dateFromString(fullNameArr[1])
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "hh:mm a"
        dateFormatter1.AMSymbol = "am"
        dateFormatter1.PMSymbol = "pm"
        let strDate = dateFormatter1.stringFromDate(date!)
        return strDate
    }
    
    func getFormattedTimeFromStringAMPMNew(dateString:String)->String{
        
        print(dateString)
        let fullNameArr = dateString.componentsSeparatedByString(" ")
        print(fullNameArr)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(dateString)
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd hh:mm a"
        let strDate = dateFormatter1.stringFromDate(date!)
        return strDate
    }
    
    func getRosterDayFormattedDate(dateString:String)->String{
        
        print(dateString)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.dateFromString(dateString)
        let dateFormatter1 = NSDateFormatter()
        dateFormatter1.dateFormat = "EEE. dd MMM. yyyy"
        let strDate = dateFormatter1.stringFromDate(date!)
        return strDate
    }
    
    
    func zipMyFiles(newZipFile:String, filePath:String , vc:UIViewController) {
        
        if !CommonFunctions.sharedInstance.canCreateZip(filePath) {
            
            try! kFileManager.removeItemAtPath(filePath)
            CommonFunctions.sharedInstance.showAlert(kAlertTitle, message: "You do not have enough space to create zip file", vc: vc)
            return
        }
        
        let success = SSZipArchive.createZipFileAtPath(newZipFile, withFilesAtPaths: [filePath])
        if success {
            try! kFileManager.removeItemAtPath(filePath)
            print("Zip file created successfully")
            self.shareMyFile(newZipFile, vc: vc)
        }
        
    }
    
    
    func zipAllMyFiles(newZipFile:String , vc:UIViewController, files : [FBFile]) -> Bool {
        
        var arrayPaths = [String]()
        let folderPath = newZipFile.stringByReplacingOccurrencesOfString(".zip", withString: "")
        for item in files {
            arrayPaths.append(item.filePath.path!)
        }
        
        do{
            
            var cacheDir = CommonFunctions.sharedInstance.docDirPath()
            cacheDir += "/test\(Timestamp)"
            
            do{
                try kFileManager.createDirectoryAtPath(cacheDir, withIntermediateDirectories: false, attributes: nil)
            }catch let e as NSError{
                print(e)
            }
            
            
            
            for item in arrayPaths {
                
                let newUrl = NSURL(fileURLWithPath: item)
                let name = item.componentsSeparatedByString("/").last
                let newPath = cacheDir+"/"+name!
                let newUrlFile = NSURL(fileURLWithPath: newPath)
                try kFileManager.copyItemAtURL(newUrl, toURL: newUrlFile)
            }
            
            let success = SSZipArchive.createZipFileAtPath(newZipFile, withContentsOfDirectory: cacheDir)
            if success {
                print("Zip file created successfully")
                
                try! kFileManager.removeItemAtPath(cacheDir)
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
    
    func shareMyFile(zipPath:String, vc:UIViewController) -> Void {
        
        let fileDAta = NSURL(fileURLWithPath: zipPath)
        
        let ac = UIActivityViewController(activityItems: [fileDAta,"hello"] , applicationActivities: nil)
        ac.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]
        ac.setValue("My file", forKey: "Subject")
        
        if let popoverPresentationController = ac.popoverPresentationController {
            popoverPresentationController.sourceView = vc.view
            var rect=vc.view.frame
            rect.origin.y = rect.height
            popoverPresentationController.sourceRect = rect
        }
        vc.presentViewController(ac, animated: true, completion: nil)
        
    }
    
    
    func docDirPath() -> String {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        return directoryPath!
    }
    
    func report_memory() {
        // constant
        let MACH_TASK_BASIC_INFO_COUNT = (sizeof(mach_task_basic_info_data_t) / sizeof(natural_t))
        
        // prepare parameters
        let name   = mach_task_self_
        let flavor = task_flavor_t(MACH_TASK_BASIC_INFO)
        var size   = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)
        
        // allocate pointer to mach_task_basic_info
        let infoPointer = UnsafeMutablePointer<mach_task_basic_info>.alloc(1)
        
        // call task_info - note extra UnsafeMutablePointer(...) call
        let kerr = task_info(name, flavor, UnsafeMutablePointer(infoPointer), &size)
        
        // get mach_task_basic_info struct out of pointer
        let info = infoPointer.move()
        
        // deallocate pointer
        infoPointer.dealloc(1)
        
        // check return value for success / failure
        if kerr == KERN_SUCCESS {
            print("Memory in use (in MB): \(info.resident_size/1000000)")
            print("Memory in use (in MB): \(info.resident_size_max/1000000)")
            
            let remSize = ( info.resident_size_max - info.resident_size ) / 1000000
            print("Free Memory): \(remSize)")
            
            
        } else {
            let errorString = String(CString: mach_error_string(kerr), encoding: NSASCIIStringEncoding)
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
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        do{
            
            let dictionary = try kFileManager.attributesOfFileSystemForPath(paths.last!)
            
            if !dictionary.isEmpty {
                let fileSystemSizeInBytes = dictionary[NSFileSystemSize]
                let freeFileSystemSizeInBytes = dictionary[NSFileSystemFreeSize]
                totalSpace = (fileSystemSizeInBytes?.unsignedLongLongValue)!
                totalFreeSpace = (freeFileSystemSizeInBytes?.unsignedLongLongValue)!
                print("Memory Capacity of \( ((totalSpace/1024)/1024) ) MiB with \( ((totalFreeSpace/1024)/1024) ) MiB Free memory available.")
            }
            return totalFreeSpace
            
        }catch let error{
            
            print(error)
            return totalFreeSpace
            
        }
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
    
    func getFolderSize(directoryPath:String) -> CUnsignedLongLong {
        
        var totalFolderSize:CUnsignedLongLong = 0
        
        if fileIsDir(directoryPath) {
            
            if let enumerator = kFileManager.enumeratorAtPath(directoryPath) {
                while let fileName = enumerator.nextObject() as? String {
                    
                    totalFolderSize += getFileSize("\(directoryPath)/\(fileName)")
                    
                }
            }
            
        }else{
            
            totalFolderSize = getFileSize(directoryPath)
            
        }
        
        
        return totalFolderSize
    }
    
    func getFileSize(filePath:String) -> CUnsignedLongLong {
        
        var fileSize:CUnsignedLongLong = 0
        
        if fileIsDir(filePath) {
            
            return getFolderSize(filePath)
            
        }else{
            
            do{
                //                var fileSize : UInt64 = 0
                let attr:NSDictionary? = try kFileManager.attributesOfItemAtPath(filePath)
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
    
    
    func fileIsDir(path: String) -> Bool {
        var isDir: ObjCBool = false;
        kFileManager.fileExistsAtPath(path, isDirectory: &isDir)
        return Bool(isDir);
    }
    
    func canCreateZip(path: String) -> Bool {
        
        let freeSpace = getFreeDiscSpase()
        let fileSpace = getFolderSize(path)
        let difference = freeSpace - fileSpace
        if difference > 0 {
            return true
        }
        return false
    }
    
    func canCreateZip2(path: [String]) -> Bool {
        
        let freeSpace = getFreeDiscSpase()
        var fileSpace:CUnsignedLongLong = 0
        
        for item in path {
            fileSpace = getFolderSize(item)
        }
        
        
        let difference = freeSpace - fileSpace
        if difference > 0 {
            return true
        }
        return false
    }
    
    
    // Helper for showing an alert
    func showAlert(title : String, message: String, vc:UIViewController) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil
        )
        alert.addAction(ok)
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
}


extension String{
    
    func isValidName () -> Bool {
        
        let emailFormat = "^[a-zA-Z0-9_-]{1,100}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(self)
    }
    
}
