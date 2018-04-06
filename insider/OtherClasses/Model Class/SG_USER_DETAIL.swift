//
//	SG_USER_DETAIL.swift
//
//	Create by IOS Developer on 11/4/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SG_USER_DETAIL : NSObject, NSCoding{

	var accessToken : Any
	var createddate : String!
	var cretedby : String!
	var deviceToken : String!
	var deviceType : String!
	var email : String!
	var firstName : String!
	var id : String!
	var lastName : String!
	var locationId : String!
	var loginFlag : String!
	var majorId : String!
	var modifiedby : String!
	var modifydatetime : String!
	var password : String!
	var photo : String!
	var schoolId : String!
	var status : String!
	var userRole : String!
	var year : String!
    var major : String!
    var campus : String!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
     address1
     major_name
	 */
	init(fromDictionary dictionary: [String:Any]){
		accessToken = dictionary["access_token"] ?? "error"
		createddate = dictionary["createddate"] as? String
		cretedby = dictionary["cretedby"] as? String
		deviceToken = dictionary["device_token"] as? String
		deviceType = dictionary["device_type"] as? String
		email = dictionary["email"] as? String
		firstName = dictionary["first_name"] as? String
		id = dictionary["id"] as? String
		lastName = dictionary["last_name"] as? String
		locationId = dictionary["location_id"] as? String
		loginFlag = dictionary["login_flag"] as? String
		majorId = dictionary["major_id"] as? String
		modifiedby = dictionary["modifiedby"] as? String
		modifydatetime = dictionary["modifydatetime"] as? String
		password = dictionary["password"] as? String
		photo = dictionary["photo"] as? String
		schoolId = dictionary["school_id"] as? String
		status = dictionary["status"] as? String
		userRole = dictionary["user_role"] as? String
		year = dictionary["year"] as? String
        major = dictionary["major"] as? String
        campus = dictionary["campus"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = [String:Any]()
		if accessToken != nil{
			dictionary["access_token"] = accessToken
		}
		if createddate != nil{
			dictionary["createddate"] = createddate
		}
		if cretedby != nil{
			dictionary["cretedby"] = cretedby
		}
		if deviceToken != nil{
			dictionary["device_token"] = deviceToken
		}
		if deviceType != nil{
			dictionary["device_type"] = deviceType
		}
		if email != nil{
			dictionary["email"] = email
		}
		if firstName != nil{
			dictionary["first_name"] = firstName
		}
		if id != nil{
			dictionary["id"] = id
		}
		if lastName != nil{
			dictionary["last_name"] = lastName
		}
		if locationId != nil{
			dictionary["location_id"] = locationId
		}
		if loginFlag != nil{
			dictionary["login_flag"] = loginFlag
		}
		if majorId != nil{
			dictionary["major_id"] = majorId
		}
		if modifiedby != nil{
			dictionary["modifiedby"] = modifiedby
		}
		if modifydatetime != nil{
			dictionary["modifydatetime"] = modifydatetime
		}
		if password != nil{
			dictionary["password"] = password
		}
		if photo != nil{
			dictionary["photo"] = photo
		}
		if schoolId != nil{
			dictionary["school_id"] = schoolId
		}
		if status != nil{
			dictionary["status"] = status
		}
		if userRole != nil{
			dictionary["user_role"] = userRole
		}
		if year != nil{
			dictionary["year"] = year
		}
        if major != nil{
            dictionary["major"] = major
        }
        if campus != nil{
            dictionary["campus"] = campus
        }
		return dictionary as NSDictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         accessToken = aDecoder.decodeObject(forKey: "access_token") ?? "error" 
         createddate = aDecoder.decodeObject(forKey: "createddate") as? String
         cretedby = aDecoder.decodeObject(forKey: "cretedby") as? String
         deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
         deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         locationId = aDecoder.decodeObject(forKey: "location_id") as? String
         loginFlag = aDecoder.decodeObject(forKey: "login_flag") as? String
         majorId = aDecoder.decodeObject(forKey: "major_id") as? String
         modifiedby = aDecoder.decodeObject(forKey: "modifiedby") as? String
         modifydatetime = aDecoder.decodeObject(forKey: "modifydatetime") as? String
         password = aDecoder.decodeObject(forKey: "password") as? String
         photo = aDecoder.decodeObject(forKey: "photo") as? String
         schoolId = aDecoder.decodeObject(forKey: "school_id") as? String
         status = aDecoder.decodeObject(forKey: "status") as? String
         userRole = aDecoder.decodeObject(forKey: "user_role") as? String
         year = aDecoder.decodeObject(forKey: "year") as? String
        major = aDecoder.decodeObject(forKey: "major") as? String
        campus = aDecoder.decodeObject(forKey: "campus") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if accessToken != nil{
			aCoder.encode(accessToken, forKey: "access_token")
		}
		if createddate != nil{
			aCoder.encode(createddate, forKey: "createddate")
		}
		if cretedby != nil{
			aCoder.encode(cretedby, forKey: "cretedby")
		}
		if deviceToken != nil{
			aCoder.encode(deviceToken, forKey: "device_token")
		}
		if deviceType != nil{
			aCoder.encode(deviceType, forKey: "device_type")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if locationId != nil{
			aCoder.encode(locationId, forKey: "location_id")
		}
		if loginFlag != nil{
			aCoder.encode(loginFlag, forKey: "login_flag")
		}
		if majorId != nil{
			aCoder.encode(majorId, forKey: "major_id")
		}
		if modifiedby != nil{
			aCoder.encode(modifiedby, forKey: "modifiedby")
		}
		if modifydatetime != nil{
			aCoder.encode(modifydatetime, forKey: "modifydatetime")
		}
		if password != nil{
			aCoder.encode(password, forKey: "password")
		}
		if photo != nil{
			aCoder.encode(photo, forKey: "photo")
		}
		if schoolId != nil{
			aCoder.encode(schoolId, forKey: "school_id")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if userRole != nil{
			aCoder.encode(userRole, forKey: "user_role")
		}
		if year != nil{
			aCoder.encode(year, forKey: "year")
		}
        if major != nil{
            aCoder.encode(major, forKey: "major")
        }
        if campus != nil{
            aCoder.encode(campus, forKey: "campus")
        }

	}

}
