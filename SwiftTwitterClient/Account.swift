//
//  Account.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/27/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

var _currentAccount: Account?
let currentAccountKey: NSString = "swiftCurrentUserAccount-o0L31Ud5li"

class Account: NSObject {
    
    var user: User?
    var accessToken: NSString?
    
    init(user: User, accessToken: NSString) {
        self.user = user
        self.accessToken = accessToken
    }
    
    init(dictionary: NSDictionary) {
        self.user = User(dictionary: dictionary["user"] as NSDictionary)
        self.accessToken = dictionary["accessToken"] as? NSString
    }
    
    func serialize () -> NSData {
        var dict: Dictionary = Dictionary<String, AnyObject>()
        dict.updateValue(self.user!.dictionary!, forKey: "user")
        dict.updateValue(self.accessToken!, forKey: "accessToken")
        
        return NSJSONSerialization.dataWithJSONObject(dict, options: nil, error: nil)!
    }
    
    class var currentAccount: Account? {
        get {
            if (_currentAccount == nil) {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentAccountKey) as NSData?
                if (data != nil) {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentAccount = Account(dictionary: dictionary)
                }
            }
            return _currentAccount
        }
        set(account) {
            _currentAccount = account
            
            if _currentAccount != nil {
                var data = _currentAccount?.serialize()
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentAccountKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentAccountKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func logout() {
        Account.currentAccount = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSUserDefaults.standardUserDefaults().removeObjectForKey(currentAccountKey)
    }
    
}
