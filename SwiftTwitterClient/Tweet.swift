//
//  Tweet.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/27/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var dictionary: NSDictionary?

    var favorite_count: NSInteger?
    var favorited: Bool?
    var id: NSInteger?
    var in_reply_to_status_id: NSInteger?
    var in_reply_to_user_id: NSInteger?
    var retweet_count: NSInteger?
    var retweeted: Bool?
    var text: NSString?
    var user: User?
    var created_at: NSString?
   
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary["id"] as? NSInteger
        text = dictionary["text"] as? NSString
        favorite_count = dictionary["favorite_count"] as? NSInteger
        retweet_count = dictionary["retweet_count"] as? NSInteger
        user = User(dictionary: dictionary["user"] as NSDictionary)
        retweeted = dictionary["retweeted"] as? Bool
        in_reply_to_status_id = dictionary["in_reply_to_status_id"] as? NSInteger
        in_reply_to_user_id  = dictionary["in_reply_to_user_id"] as? NSInteger
        created_at = dictionary["created_at"] as? NSString
        favorited = dictionary["favorited"] as? Bool
    }
}
