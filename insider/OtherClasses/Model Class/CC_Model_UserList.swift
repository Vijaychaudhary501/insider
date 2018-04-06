//
//	CC_Model_UserList.swift
//
//	Create by Priyank Gandhi on 12/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CC_Model_UserList : NSObject, NSCoding{

	var chatUserId : Int!
	var chatUserLastConversationMsg : String!
	var chatUserLastConversationTime : String!
	var chatUserName : String!
	var chatUserProfilePhoto : String!
	var chatUserUnreadMessage : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		chatUserId = dictionary["chat_user_id"] as? Int
		chatUserLastConversationMsg = dictionary["chat_user_last_conversation_msg"] as? String
		chatUserLastConversationTime = dictionary["chat_user_last_conversation_time"] as? String
		chatUserName = dictionary["chat_user_name"] as? String
		chatUserProfilePhoto = dictionary["chat_user_profile_photo"] as? String
		chatUserUnreadMessage = dictionary["chat_user_unread_message"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if chatUserId != nil{
			dictionary["chat_user_id"] = chatUserId
		}
		if chatUserLastConversationMsg != nil{
			dictionary["chat_user_last_conversation_msg"] = chatUserLastConversationMsg
		}
		if chatUserLastConversationTime != nil{
			dictionary["chat_user_last_conversation_time"] = chatUserLastConversationTime
		}
		if chatUserName != nil{
			dictionary["chat_user_name"] = chatUserName
		}
		if chatUserProfilePhoto != nil{
			dictionary["chat_user_profile_photo"] = chatUserProfilePhoto
		}
		if chatUserUnreadMessage != nil{
			dictionary["chat_user_unread_message"] = chatUserUnreadMessage
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         chatUserId = aDecoder.decodeObject(forKey: "chat_user_id") as? Int
         chatUserLastConversationMsg = aDecoder.decodeObject(forKey: "chat_user_last_conversation_msg") as? String
         chatUserLastConversationTime = aDecoder.decodeObject(forKey: "chat_user_last_conversation_time") as? String
         chatUserName = aDecoder.decodeObject(forKey: "chat_user_name") as? String
         chatUserProfilePhoto = aDecoder.decodeObject(forKey: "chat_user_profile_photo") as? String
         chatUserUnreadMessage = aDecoder.decodeObject(forKey: "chat_user_unread_message") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if chatUserId != nil{
			aCoder.encode(chatUserId, forKey: "chat_user_id")
		}
		if chatUserLastConversationMsg != nil{
			aCoder.encode(chatUserLastConversationMsg, forKey: "chat_user_last_conversation_msg")
		}
		if chatUserLastConversationTime != nil{
			aCoder.encode(chatUserLastConversationTime, forKey: "chat_user_last_conversation_time")
		}
		if chatUserName != nil{
			aCoder.encode(chatUserName, forKey: "chat_user_name")
		}
		if chatUserProfilePhoto != nil{
			aCoder.encode(chatUserProfilePhoto, forKey: "chat_user_profile_photo")
		}
		if chatUserUnreadMessage != nil{
			aCoder.encode(chatUserUnreadMessage, forKey: "chat_user_unread_message")
		}

	}

}
