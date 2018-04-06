//
//  ClassList.swift
//  Student_GPA
//
//  Created by mac 2 on 07/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation

class ClassList: NSObject,NSCoding {
    
    
    
    var id: String = ""
    var user_id : String = ""
    var school_id : String = ""
    var crn_id : String = ""
    var course_id : String = ""
    var teacher_id : String = ""
    var class_type : String = ""
    var title : String = ""
    var books : String = ""
    var notes : String = ""
    var createddate : String = ""
    var createdby : String = ""
    var modifydatetime : String = ""
    var modifiedby : String = ""
    var crn_no : String = ""
    var school_name : String = ""
    var course_name : String = ""
    var teacher_name : String = ""
    
    override init() {
        super.init()
    }
    init(id: String,user_id : String ,school_id : String ,crn_id : String ,course_id : String ,teacher_id : String ,class_type : String,title : String ,books : String ,notes : String ,createddate : String ,createdby : String ,modifydatetime : String ,modifiedby : String ,crn_no : String ,school_name : String ,course_name : String ,teacher_name : String) {
        
        
        self.id = id
        self.user_id = user_id
        self.school_id = school_id
        self.crn_id = crn_id
        self.course_id = course_id
        self.teacher_id = teacher_id
        self.class_type = class_type
        self.title = title
        self.books = books
        self.notes = notes
        self.createddate = createddate
        self.createdby = createdby
        self.modifydatetime = modifydatetime
        self.modifiedby = modifiedby
        self.crn_no = crn_no
        self.school_name = school_name
        self.course_name = course_name
        self.teacher_name = teacher_name
        
    }
    required init(coder decoder: NSCoder) {
        
        self.id = decoder.decodeObject(forKey: "id") as! String
        self.user_id  = decoder.decodeObject(forKey:"user_id" ) as! String
       self.school_id  = decoder.decodeObject(forKey:"school_id" ) as! String
        self.crn_id  = decoder.decodeObject(forKey:"crn_id" ) as! String
        self.course_id  = decoder.decodeObject(forKey:"course_id" ) as! String
        self.teacher_id  = decoder.decodeObject(forKey:"teacher_id" ) as! String
        self.class_type  = decoder.decodeObject(forKey:"class_type" ) as! String
        self.title  = decoder.decodeObject(forKey:"title" ) as! String
        self.books  = decoder.decodeObject(forKey:"books" ) as! String
        self.notes  = decoder.decodeObject(forKey:"notes" ) as! String
        self.createddate  = decoder.decodeObject(forKey:"createddate" ) as! String
        self.createdby  = decoder.decodeObject(forKey:"createdby" ) as! String
        self.modifydatetime  = decoder.decodeObject(forKey:"modifydatetime" ) as! String
        self.modifiedby  = decoder.decodeObject(forKey:"modifiedby" ) as! String
        self.crn_no  = decoder.decodeObject(forKey:"crn_no" ) as! String
        self.school_name  = decoder.decodeObject(forKey:"school_name" ) as! String
        self.course_name  = decoder.decodeObject(forKey:"course_name" ) as! String
        self.user_id  = decoder.decodeObject(forKey:"user_id" ) as! String
        
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey:"id")
        aCoder.encode(self.user_id, forKey:"user_id")
        aCoder.encode(self.school_id, forKey:"school_id")
        aCoder.encode(self.crn_id, forKey:"crn_id")
        aCoder.encode(self.course_id, forKey:"course_id")
        aCoder.encode(self.teacher_id, forKey:"teacher_id")
        aCoder.encode(self.class_type, forKey:"class_type")
        aCoder.encode(self.title, forKey:"title")
        aCoder.encode(self.books, forKey:"books")
        aCoder.encode(self.notes, forKey:"notes")
        aCoder.encode(self.createddate, forKey:"createddate")
        aCoder.encode(self.createdby, forKey:"createdby")
        aCoder.encode(self.modifydatetime, forKey:"modifydatetime")
        aCoder.encode(self.modifiedby, forKey:"modifiedby")
        aCoder.encode(self.crn_no, forKey:"crn_no")
        aCoder.encode(self.school_name, forKey:"school_name")
        aCoder.encode(self.course_name, forKey:"course_name")
        aCoder.encode(self.user_id, forKey:"user_id")
        
    }

    

}


/*
 {"id":"85","user_id":"21","school_id":"2","crn_id":"77710","course_id":"1","teacher_id":"3","class_type":"Previous","title":"Title*","books":"yes","notes":"yes","createddate":"07\/06\/2017 05:21","createdby":"21","modifydatetime":"07\/06\/2017 05:21","modifiedby":"0","crn_no":"77710","school_name":"Kalp ","course_name":"Arithmatic","teacher_name":"Hetali"}
 */
