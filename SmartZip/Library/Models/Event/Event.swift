//
//  Event.swift
//  __PRODUCTNAME__
//
//  Created by Pawan Kumar on 16/06/15
//  Copyright (c) __ORGANIZATIONNAME__. All rights reserved.
//

import UIKit
import ObjectMapper
 

class Event: Mappable {
    
    var location_name: String?
    
    var distance: String?
    
    var business_title: String?
    
    var is_favourite: String?
    
    var event_id: String?
    
    var location_id: String?
    
    var product_title: String?
    
    var event_img: String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        location_name <- map["location_name"]
        distance <- map["distance"]
        business_title <- map["business_title"]
        is_favourite <- map["is_favourite"]
        event_id <- map["event_id"]
        location_id <- map["location_id"]
        product_title <- map["product_title"]
        event_img <- map["event_img"]
    }
}


//let user = Mapper<User>().map(JSONString)