//
//  SG_POST_DATA.swift
//  Student_GPA
//
//  Created by mac 2 on 02/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation

class SG_POST_DATA: NSObject, NSCoding{
    
    var created_by : String!
    var created_date : String!
    var post_description : String!
    var post_id : String!
    var post_type : String!
    var school_id : String!
    var like = [[String:String]]()
    var tagged = [[String:String]]()
    var photo : String!
    var attachements = [[String:String]]()
    var user_id : String!
    var insight_user : String!
    var comments = [[String:String]]()
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        created_by = dictionary["created_by"] as? String
        created_date = dictionary["created_date"] as? String
        post_description = dictionary["post_description"] as? String
        post_id = dictionary["post_id"] as? String
        post_type = dictionary["post_type"] as? String
        user_id = dictionary["user_id"] as? String
        insight_user = dictionary["insight_user"] as? String
        school_id = dictionary["school_id"] as? String
        like = (dictionary["like"] as? [[String:String]])!
        tagged = (dictionary["tagged"] as? [[String:String]])!
        attachements = (dictionary["attachements"] as? [[String:String]])!
        photo = (dictionary["photo"] as? String)
        comments = (dictionary["comments"] as? [[String:String]])!
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        var dictionary = [String:Any]()
        if created_by  != nil{
            dictionary["created_by"] = created_by
        }
        if created_date != nil{
            dictionary["created_date"] = created_date
        }
        if user_id != nil{
            dictionary["user_id"] = user_id
        }
        if insight_user != nil {
            dictionary["insight_user"] = insight_user
        }
        if post_description != nil{
            dictionary["post_description"] = post_description
        }
        if post_id != nil{
            dictionary["post_id"] = post_id
        }
        if post_type != nil{
            dictionary["post_type"] = post_type
        }
        if school_id != nil{
            dictionary["school_id"] = school_id
        }
        if photo != nil{
            dictionary["photo"] = photo
        }
        if like.count > 0{
            dictionary["like"] = like
        }
        if tagged.count > 0{
            dictionary["tagged"] = tagged
        }
        if attachements.count > 0{
            dictionary["attachements"] = attachements
        }
        if comments.count > 0{
            dictionary["comments"] = comments
        }
        return dictionary as NSDictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        created_by = aDecoder.decodeObject(forKey: "created_by") as? String
        created_date = aDecoder.decodeObject(forKey: "created_date") as? String
        post_description = aDecoder.decodeObject(forKey: "post_description") as? String
        post_id = aDecoder.decodeObject(forKey: "post_id") as? String
        post_type = aDecoder.decodeObject(forKey: "post_type") as? String
        school_id = aDecoder.decodeObject(forKey: "school_id") as? String
        user_id = aDecoder.decodeObject(forKey: "user_id") as? String
        insight_user = aDecoder.decodeObject(forKey:"insight_user") as? String
        like = (aDecoder.decodeObject(forKey: "like") as? [[String:String]])!
        tagged = (aDecoder.decodeObject(forKey: "tagged") as? [[String:String]])!
        attachements = (aDecoder.decodeObject(forKey: "attachements") as? [[String:String]])!
        photo = aDecoder.decodeObject(forKey: "photo") as? String
        comments = (aDecoder.decodeObject(forKey: "comments") as? [[String:String]])!
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if created_by != nil{
            aCoder.encode(created_by, forKey: "created_by")
        }
        if created_date != nil{
            aCoder.encode(created_date, forKey: "created_date")
        }
        if post_description != nil{
             aCoder.encode(post_description, forKey: "post_description")
        }
        if post_id != nil{
             aCoder.encode(post_id, forKey: "post_id")
        }
        if post_type != nil{
            aCoder.encode(post_type, forKey: "post_type")
        }
        if school_id != nil{
             aCoder.encode(school_id, forKey: "school_id")
        }
        if user_id != nil{
            aCoder.encode(user_id, forKey: "user_id")
        }
        if insight_user != nil {
            aCoder.encode(insight_user, forKey:"insight_user")
        }
        if photo != nil{
            aCoder.encode(photo, forKey: "photo")
        }
        if like.count > 0{
             aCoder.encode(like, forKey: "like")
        }
        if tagged.count > 0{
             aCoder.encode(tagged, forKey: "tagged")
        }
        if attachements.count > 0{
            aCoder.encode(attachements, forKey: "attachements")
        }
        if comments.count > 0{
            aCoder.encode(comments, forKey: "comments")
        }
    }
    
}


