//
//  StoryDataModal.swift
//  Student_GPA
//
//  Created by mac 2 on 26/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation

class StoryDataModal: NSObject,NSCoding {
/*
     "user_id":"21","first_name":"Shrutifirst Name","last_name":"Vyaslast Name","full_name":"Shrutifirst Name Vyaslast Name","photo":"http:\/\/kalpcorp.in\/insight\/uploads\/1496992932_21_post_files.jpeg","user_stories":[{"type":"photo","file_name":"http:\/\/kalpcorp.in\/insight\/uploads\/1498292890_story_21_Penguins.jpg","display_time":""}]
 */

    var first_name : String!
    var last_name : String!
    var full_name : String!
    
    var photo : String!
    var user_stories = [[String:String]]()
    var user_id : String!
    var school_id : String!
     var insight_user : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        full_name = dictionary["full_name"] as? String
        
        user_id = dictionary["user_id"] as? String
        
        user_stories = (dictionary["user_stories"] as? [[String:String]])!
        photo = (dictionary["photo"] as? String)
        
        school_id = dictionary["school_id"] as? String
       
        insight_user = dictionary["insight_user"] as? String

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
        if last_name != nil{
            dictionary["last_name"] = last_name
        }
        if user_id != nil{
            dictionary["user_id"] = user_id
        }
        if full_name != nil{
            dictionary["full_name"] = full_name
        }
        if photo != nil{
            dictionary["photo"] = photo
        }
        if user_stories.count > 0{
            dictionary["user_stories"] = user_stories
        }
        
        if school_id != nil{
            dictionary["school_id"] = school_id
        }
        if insight_user != nil {
            dictionary["insight_user"] = insight_user
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
        full_name = aDecoder.decodeObject(forKey: "full_name") as? String
        user_id = aDecoder.decodeObject(forKey: "user_id") as? String
        
        user_stories = (aDecoder.decodeObject(forKey: "user_stories") as? [[String:String]])!
        photo = aDecoder.decodeObject(forKey: "photo") as? String
        school_id = aDecoder.decodeObject(forKey: "school_id") as? String
        
        insight_user = aDecoder.decodeObject(forKey:"insight_user") as? String
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
        if full_name != nil{
            aCoder.encode(full_name, forKey: "full_name")
        }
        if user_id != nil{
            aCoder.encode(user_id, forKey: "user_id")
        }
        
        if photo != nil{
            aCoder.encode(photo, forKey: "photo")
        }
        if user_stories.count > 0{
            aCoder.encode(user_stories, forKey: "user_stories")
        }
        if school_id != nil{
            aCoder.encode(school_id, forKey: "school_id")
        }
        
        if insight_user != nil {
            aCoder.encode(insight_user, forKey:"insight_user")
        }
    }


}
