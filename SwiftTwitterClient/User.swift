//
//  User.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/27/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

class User: NSObject {
    var dictionary: NSDictionary?

    var id: NSInteger?
    var name: NSString?
    var screen_name: NSString?
    var profile_image_url: NSString?
    var followers_count: NSInteger?
    var friends_count: NSInteger?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id"] as? NSInteger
        name = dictionary["name"] as? NSString
        screen_name = dictionary["screen_name"] as? NSString
        profile_image_url = dictionary["profile_image_url"] as? NSString
        followers_count = dictionary["followers_count"] as? NSInteger
        friends_count = dictionary["friends_count"] as? NSInteger
    }
}
