//
//  TeacherList.swift
//  Student_GPA
//
//  Created by mac 2 on 24/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation

class TeacherList:NSObject, NSCoding {
    
    /*
     "id":"3","name":"Hetali","teacher_photo":"http:\/\/kalpcorp.in\/insight\/uploads\/1495084712Penguins.jpg","rated_teacher":1
     
     */
    var id: String = ""
    var name: String = ""
    var rated_teacher: Int = 0
    var teacher_photo: String = ""
    var average_rating: String = ""
    
    override init() {
        super.init()
    }
    init(id:String,rated_teacher:Int,name:String,photo:String,average_rating: String) {
        
        
        self.id = id
        self.rated_teacher = rated_teacher
        self.name = name
        self.teacher_photo = photo
        self.average_rating = average_rating
    }
    required init(coder decoder: NSCoder) {
        
        self.id = decoder.decodeObject(forKey: "id") as! String
        self.rated_teacher = decoder.decodeObject(forKey:"rated_teacher" ) as! Int
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.teacher_photo = decoder.decodeObject(forKey: "teacher_photo") as! String
         self.average_rating = decoder.decodeObject(forKey: "average_rating") as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey:"id")
        
        aCoder.encode(self.rated_teacher, forKey:"rated_teacher")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.teacher_photo, forKey: "teacher_photo")
        aCoder.encode(self.average_rating, forKey: "average_rating")
    }
}
