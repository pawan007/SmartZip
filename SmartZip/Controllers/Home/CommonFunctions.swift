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
        
        let success = SSZipArchive.createZipFileAtPath(newZipFile, withFilesAtPaths: [filePath])
        if success {
            print("Zip file created successfully")
            self.shareMyFile(newZipFile, vc: vc)
        }
        
    }
    
    func shareMyFile(zipPath:String, vc:UIViewController) -> Void {
        
        let fileDAta = NSURL(fileURLWithPath: zipPath)
        
        let ac = UIActivityViewController(activityItems: [fileDAta,"hello"] , applicationActivities: nil)
        ac.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]
        ac.setValue("My file", forKey: "Subject")
        vc.presentViewController(ac, animated: true, completion: nil)
        
    }
    
    
    func docDirPath() -> String {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        return directoryPath!
    }
    
}
