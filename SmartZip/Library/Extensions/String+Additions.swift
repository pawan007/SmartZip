//
//  String+Additions.swift
//
//  Created by Pawan Joshi on 30/03/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
// MARK: - String Extension
extension String {
    
    /**
     String length
     */
    var length: Int { return self.characters.count }
    
    /**
     Reverse of string
     */
    var reverse: String { return String(self.characters.reversed()) }

    /**
     Convert html string into  normal string
     */
    var html2AttributedString: NSAttributedString? {
        guard
            let data = self.data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    /**
     Get height of string

     - parameter width: Max width of string to calculate height
     - parameter font:  Font of string
     
     - returns: Height of string
     */
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    /**
     Get width of string
     
     - parameter width: Max width of string to calculate height
     - parameter font:  Font of string
     
     - returns: Height of string
     */
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    /**
     Replace occurance of charater
     
     - parameter string: String which want to replace
     - parameter replacementString : New string at place of previous string
     - returns: Updated string after replacement
     */
    func replace(_ string: String, replacementString: String) -> String {
        
        return self.replacingOccurrences(of: string, with: replacementString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /**
     Replace occurance of space in string
     
     - returns: A String after remove white space
     */
    func removeWhitespaceInString() -> String {
        
        return self.replace(" ", replacementString: "")
    }
    
    func removeCharacterInCharacterSet(_ set: CharacterSet) -> String  {
        let tempArr = self.components(separatedBy: set)
        return tempArr.joined(separator: "")
        
    }
    
    /**
     Returns the substring in the given range
     
     - parameter range: specify the range to get string
     - returns: Substring in range
     */
    subscript (range: Range<Int>) -> String? {
      
        if range.lowerBound < 0 || range.upperBound > self.length {
            return nil
        }
        
//        let range = Range(start: startIndex.advancedBy(range.startIndex), end: startIndex.advancedBy(range.endIndex))
        let range = characters.index(startIndex, offsetBy: range.lowerBound) ..< characters.index(startIndex, offsetBy: range.upperBound)
        return self[range]
    }
    
    /**
     Gets the character at the specified index as String.
     If index is negative it is assumed to be relative to the end of the String.
     
     - parameter index: Position of the character to get
     - returns: Character as String or nil if the index is out of bounds
     */
    subscript (i: Int) -> Character {
       
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    /**
     Takes a list of indexes and returns an Array containing the elements at the given indexes in self.
     
     - parameter indexes: Positions of the elements to get
     - returns: Array of characters (as String)
     */
    subscript (i: Int) -> String {
       
        return String(self[i] as Character)
    }
    
    /**
     Inserts a substring at the given index in self.
     
     - parameter index: Where the new string is inserted
     - parameter string: String to insert
     - returns: String formed from self inserting string at index
     */
    func insert (_ index: Int, _ string: String) -> String {
        
        //  Edge cases, prepend and append
        if index > length {
            return self + string
        } else if index < 0 {
            return string + self
        }
        
        return self[0..<index]! + string + self[index..<length]!
    }
    
    /**
     Strips the specified characters from the beginning of string.
     
     - parameter set: Give character set to apply on string for trimming
     
     - returns: A String trimmed after left whitespace
     */
    func trimmedLeft (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
       
        if let range = rangeOfCharacter(from: set.inverted) {
            return self[range.lowerBound..<endIndex]
        }
        
        return ""
    }
    
    @available (*, unavailable, message: "use 'trimmedLeft' instead") func ltrimmed (_ set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        
        return trimmedLeft(characterSet: set)
    }
    
    /**
     Strips the specified characters from the end of string.
     
     - parameter set: Give character set to apply on string for trimming
     
     - returns: A String trimmed after right whitespace
     */
    func trimmedRight (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
       
        if let range = rangeOfCharacter(from: set.inverted, options: NSString.CompareOptions.backwards) {
            return self[startIndex..<range.upperBound]
        }
        
        return ""
    }
    
    @available(*, unavailable, message: "use 'trimmedRight' instead") func rtrimmed (_ set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        
        return trimmedRight(characterSet: set)
    }
    
    /**
     Strips whitespaces from both the beginning and the end of string.
     
     - returns: A String after trimmed white space
     */
    func trimmed () -> String {
       
        return trimmedLeft().trimmedRight()
    }
    
    /**
     Parses a string containing a double numerical value into an optional double if the string is a well formed number.
     
     - returns: A double parsed from the string or nil if it cannot be parsed.
     */
    func toDouble () -> Double? {
        
        let scanner = Scanner(string: self)
        var double: Double = 0
        
        if scanner.scanDouble(&double) {
            return double
        }
        
        return nil
    }
    
    /**
     Parses a string containing a float numerical value into an optional float if the string is a well formed number.
     
     - returns: A float parsed from the string or nil if it cannot be parsed.
     */
    func toFloat () -> Float? {
        
        let scanner = Scanner(string: self)
        var float: Float = 0
        
        if scanner.scanFloat(&float) {
            return float
        }
        
        return nil
    }
    
    /**
     Parses a string containing a non-negative integer value into an optional UInt if the string is a well formed number.
     
     - returns: A UInt parsed from the string or nil if it cannot be parsed.
     */
    func toUInt () -> UInt? {
       
        if let val = Int(self.trimmed()) {
            if val < 0 {
                return nil
            }
            return UInt(val)
        }
        
        return nil
    }
    
    /**
     Parses a string containing a boolean value (true or false) into an optional Bool if the string is a well formed.
     
     - returns: A Bool parsed from the string or nil if it cannot be parsed as a boolean.
     */
    func toBool () -> Bool? {
       
        let text = self.trimmed().lowercased()
        if text == "true" || text == "false" || text == "yes" || text == "no" {
            return (text as NSString).boolValue
        }
        
        return nil
    }
    
    /**
     Parses a string containing a date into an optional NSDate if the string is a well formed.
    
     - parameter format: The default format is yyyy-MM-dd, but can be overriden.
     
     - returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
     */
    func toDate (_ format : String? = "yyyy-MM-dd") -> Date? {
       
        let text = self.trimmed().lowercased()
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.date(from: text)
    }
    
    /**
     Parses a string containing a date and time into an optional NSDate if the string is a well formed.
     
     - parameter format: The default format is yyyy-MM-dd hh-mm-ss, but can be overriden.
     
     - returns: A NSDate parsed from the string or nil if it cannot be parsed as a date.
     */
    func toDateTime (_ format : String? = "yyyy-MM-dd hh-mm-ss") -> Date? {
       
        return toDate(format)
    }
    
    /**
     Get nsdata from string
     
     - returns: A NSdata from string
     */
    func data () -> Data {
       
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    /**
     Get base 64 strinf from nsdata
     
     - returns: A NSString
     */
    func base64Encoded () -> String {
        
        return data().base64EncodedString(options: [NSData.Base64EncodingOptions()])
    }
    
    /**
     Returns an array of strings, each of which is a substring of self formed by splitting it on separator.
     
     - parameter separator: Character used to split the string
     - returns: Array of substrings
     */
    func explode (_ separator: Character) -> [String] {
        
        return self.characters.split(whereSeparator: { (element: Character) -> Bool in
            return element == separator
        }).map { String($0) }
    }
    
    /**
     Specify that string contains only letters.
     
     - returns: A Bool return true if only letters otherwise false.
     */
    func containsOnlyLetters () -> Bool {
        
        for chr in self.characters {
            if (!(chr >= "a" && chr <= "z") || !(chr >= "A" && chr <= "Z") ) {
                return false
            }
        }
        return true
    }
    
    /**
     Specify that string contains only number.
     
     - returns: A Bool return true if string has only letters otherwise false.
     */
    func containOnlyNumber () -> Bool {
        
        let num = Int(self)
        if num != nil {
            return true
        } else {
            return false
        }
    }
    
    /**
     Specify that string contains valid email address.
     
     - returns: A Bool return true if string has valid email otherwise false.
     */
    func isValidEmail () -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    /**
     Specify that string contains valid phone number.
     
     - returns: A Bool return true if string has valid phone number otherwise false.
     */
    func isValidPhoneNumber () -> Bool {
        
        let phoneNumberFormat = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneNumberPredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberFormat)
        return phoneNumberPredicate.evaluate(with: self)
    }
    
    /**
     Specify that string contains valid password.
     
     - returns: A Bool return true if string has valid password otherwise false.
     */
    func isValidPassword() -> Bool {

        let passwordRegex = Constants.PASSWORD_REGEX
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        let rVal = passwordTest.evaluate(with: self)
        if !rVal {
            
        }
        return rVal
    }
    
    /**
     Specify that string contains valid web url.
     
     - returns: A Bool return true if it is valid url otherwise false.
     */
    func isValidUrl () -> Bool {
        
        let urlFormat = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlPredicate = NSPredicate(format:"SELF MATCHES %@", urlFormat)
        return urlPredicate.evaluate(with: self)
    }
    
    /**
     Specify that string is empty or not.
     
     - returns: A Bool return true if string has value otherwise false.
     */
    func isNullOrEmpty () -> Bool {
        
        let optionalString: String? = self
        if optionalString == "(null)" || optionalString?.isEmpty == true {
            return true
        }
        return false
    }
    
    /**
     Get string from array
     
     - parameter array:     Array to convert into string
     - parameter seperator: String to seperate element
     
     - returns: A NSString from array seperate by seperator
     */
    func stringFromArray (_ array: NSArray, seperator: String) -> String {
       
        return array.componentsJoined(by: seperator)
    }
    
    
    /**
     Get substring in string.
     
     - returns: A Bool return true if string has substring otherwise false.
     */
    func containsSubstring () -> Bool {
       
        return self.contains(self)
    }
    
    /**
     Match password is validate or not.
     
     - parameter password: String of password
     
     - returns: A Bool return true if password is validate otherwise false
     */
    fileprivate func validatePassword(_ password:String) -> Bool {
        
        //This regular expression allowes 2 to 8 character passwords.
        //It requires to have at least 1 alphanumeric (letter/number) character and 1 non-alphanumeric character
        let passwordRegex = "^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z.!&/()=?+*~#'_:.,;-]{6,32}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    /**
     Match password with confirm password.
     
     - parameter password:        String of password
     - parameter confirmPassword: Strinf of confirm password
     
     - returns: A Bool return true if password is match with confirm password otherwise false
     */
    fileprivate func passwordComparision(_ password:String, confirmPassword:String) -> Bool {
        
        //This regular expression allowes 2 to 8 character passwords.
        //It requires to have at least 1 alphanumeric (letter/number) character and 1 non-alphanumeric character
        
        if password == confirmPassword {
            return true
        }
        return false
    }
}
