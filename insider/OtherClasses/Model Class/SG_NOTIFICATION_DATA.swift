//
//  SG_NOTIFICATION_DATA.swift
//  Student_GPA
//
//  Created by mac 2 on 03/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation

class SG_NOTIFICATION_DATA: NSObject , NSCoding{
    /*
     
     
          "user_id" = 3;
     "user_name" = "Kalp Corp";
     */
    var first_name : String!
    var last_name:String!
    var id : String!
    var user_name : String!
    var created_date : String!
    var notification_text : String!
    var post_id : String!
    var user_id : String!
    var school_id : String!
    var photo : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        id = dictionary["id"] as? String
        user_name = dictionary["user_name"] as? String
        created_date = dictionary["createddate"] as? String
        notification_text = dictionary["notification_text"] as? String
        post_id = dictionary["post_id"] as? String
        user_id = dictionary["user_id"] as? String
        school_id = dictionary["school_id"] as? String
        photo = (dictionary["photo"] as? String)
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        var dictionary = [String:Any]()
        if first_name  != nil{
            dictionary["first_name"] = first_name
        }
        if last_name  != nil{
            dictionary["last_name"] = last_name
        }
        if id  != nil{
            dictionary["id"] = id
        }
        if user_name  != nil{
            dictionary["created_by"] = user_name
        }
        if created_date != nil{
            dictionary["createddate"] = created_date
        }
        if notification_text != nil{
            dictionary["post_description"] = notification_text
        }
        if post_id != nil{
            dictionary["post_id"] = post_id
        }
        if user_id != nil{
            dictionary["post_type"] = user_id
        }
        if school_id != nil{
            dictionary["school_id"] = school_id
        }
        if photo != nil{
            dictionary["photo"] = photo
        }
        
        return dictionary as NSDictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        user_name = aDecoder.decodeObject(forKey: "created_by") as? String
        created_date = aDecoder.decodeObject(forKey: "createddate") as? String
        notification_text = aDecoder.decodeObject(forKey: "notification_text") as? String
        post_id = aDecoder.decodeObject(forKey: "post_id") as? String
        user_id = aDecoder.decodeObject(forKey: "user_id") as? String
        school_id = aDecoder.decodeObject(forKey: "school_id") as? String
        photo = aDecoder.decodeObject(forKey: "photo") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if first_name != nil{
            aCoder.encode(first_name, forKey: "first_name")
        }
        if last_name != nil{
            aCoder.encode(last_name, forKey: "last_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if user_name != nil{
            aCoder.encode(user_name, forKey: "user_name")
        }
        if created_date != nil{
            aCoder.encode(created_date, forKey: "createddate")
        }
        if notification_text != nil{
            aCoder.encode(notification_text, forKey: "notification_text")
        }
        if post_id != nil{
            aCoder.encode(post_id, forKey: "post_id")
        }
        if user_id != nil{
            aCoder.encode(user_id, forKey: "post_type")
        }
        if school_id != nil{
            aCoder.encode(school_id, forKey: "school_id")
        }
        if photo != nil{
            aCoder.encode(photo, forKey: "photo")
        }
        
    }
    
}
