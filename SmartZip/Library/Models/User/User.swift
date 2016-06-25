//
//  User.swift
//
//  Created by Sourabh Bhardwaj on 01/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//


import UIKit

class User: Model, NSCoding {
    var userId: NSNumber!
    var userName: String!
    var email: String!
    var token: String?
    
//    var _fullName: String?
    var firstName: String?
    var lastName: String?
    
    var thumbImageUrl: String?
    var imageUrl: String?
    
    
    func fullName() -> String? {
        if let _ = firstName, _ = lastName {
            return firstName! + " " + lastName!
        }
        if let _ = firstName {
            return firstName
        }
        if let _ = lastName {
            return lastName
        }
        return nil
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - NSCoding protocol methods
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.userId = aDecoder.decodeObjectForKey("userID") as? NSNumber
        self.userName = aDecoder.decodeObjectForKey("userName") as? String
        self.email = aDecoder.decodeObjectForKey("email") as? String
        self.token = aDecoder.decodeObjectForKey("token") as? String
//        self.fullName = aDecoder.decodeObjectForKey("fullName") as? String
        self.firstName = aDecoder.decodeObjectForKey("firstName") as? String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as? String
        self.thumbImageUrl = aDecoder.decodeObjectForKey("thumbImageUrl") as? String
        self.imageUrl = aDecoder.decodeObjectForKey("imageUrl") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
       aCoder.encodeObject(self.userId, forKey: "userID")
       aCoder.encodeObject(self.userName, forKey: "userName")
       aCoder.encodeObject(self.email, forKey: "email")
       aCoder.encodeObject(self.token, forKey: "token")
//       aCoder.encodeObject(self.fullName, forKey: "fullName")
       aCoder.encodeObject(self.firstName, forKey: "firstName")
       aCoder.encodeObject(self.lastName, forKey: "lastName")
       aCoder.encodeObject(self.thumbImageUrl, forKey: "thumbImageUrl")
       aCoder.encodeObject(self.imageUrl, forKey: "imageUrl")
    }
    
}

