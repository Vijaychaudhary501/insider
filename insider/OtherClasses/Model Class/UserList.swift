//
//  UserList.swift
//  Student_GPA
//
//  Created by mac 2 on 24/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation

class UserList: NSObject, NSCoding {
    
    /*
     "first_name" = dheeraj;
     id = 33;
     "last_name" = kumar;
     name = "dheeraj kumar";
     photo = "http://kalpcorp.in/insight/uploads/1495446531_33_imland1495098602007.jpeg";

 */
    var id: String? = ""
    var first_name: String = ""
    var last_name: String = ""
    var name: String = ""
    var photo: String = ""
    
    override init() {
        super.init()
    }
    init(id:String,first_name:String ,last_name:String,name:String,photo:String) {
        
        
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.name = name
        self.photo = photo
        
    }
    required init(coder decoder: NSCoder) {
        
        self.id = decoder.decodeObject(forKey: "id") as? String
        self.first_name = decoder.decodeObject(forKey:"first_name" ) as! String
        self.last_name = decoder.decodeObject(forKey: "last_name") as! String
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.photo = decoder.decodeObject(forKey: "photo") as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey:"id")
        
        aCoder.encode(self.first_name, forKey:"first_name")
        aCoder.encode(self.last_name, forKey: "last_name")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.photo, forKey: "photo")        
    }
}
