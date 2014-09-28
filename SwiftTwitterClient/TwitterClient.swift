//
//  TwitterClient.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/26/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

let twitterConsumerKey = "GvROlaDHtSStomGBPywqayqVb"
let twitterConsumerSecret = "ipDjW1dC8LpG9qP8scZsaPVbO6kaMmtcMsK8lJHjpclYCX6gqf"
let twitterAPIBaseURL = NSURL(string: "https://api.twitter.com")
let requestTokenURL = "/oauth/request_token"
let authorizeTokenURL = "/oauth/authorize"
let accessTokenURL = "/oauth/access_token"
let callbackURL = NSURL(string: "switter://oauth")

let verifyCredentialsURL = "/1.1/account/verify_credentials.json"
let homeTimelineURL = "/1.1/statuses/home_timeline.json"
let userTimelineURL = "/1.1/statuses/user_timeline.json"
let statusUpdateURL = "/1.1/statuses/update.json"
let retweetURL = "/1.1/statuses/retweet"
let favoriteURL = "/1.1/favorites/create.json"


class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginOnCompletion: ((account: Account?, error: NSError?) -> Void)?
    
    class var sharedInstance: TwitterClient {
    struct Static {
        static let instance = TwitterClient(baseURL: twitterAPIBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func login(callback: (account: Account?, error: NSError?)-> Void) {
        self.requestSerializer.removeAccessToken()
        self.fetchRequestTokenWithPath(requestTokenURL, method: "GET", callbackURL: callbackURL, scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            NSLog("Request Token was successfully obtained!")
            
            self.loginOnCompletion = callback
            
    var authURL =  NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }, failure: { (error: NSError!) in
                NSLog("Something went wrong: \(error)")
        })
    }
    
    func fetchAccessToken(url: NSURL) {
        self.fetchAccessTokenWithPath(accessTokenURL, method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            NSLog("Obtained access token")
            var accessToken = accessToken.token
            self.verifyCredentials({ (user, error) -> Void in
                if user != nil {
                    var account = Account(user: user!, accessToken: accessToken)
                    self.loginOnCompletion?(account: account, error: nil)
                    Account.currentAccount = account
                } else {
                    self.loginOnCompletion?(account: nil, error: error)
                }
            })
            }) { (error: NSError!) -> Void in
                NSLog("Failed to obtain access token")
                self.loginOnCompletion?(account: nil, error: error)
        }
    }
    
    func verifyCredentials(callback: (user: User?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.GET(verifyCredentialsURL, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var user = User(dictionary: response as NSDictionary)
            callback(user: user, error: nil)
            }) { (operations: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: \(error)")
                callback(user: nil, error: error)
        }
    }
    
    func fetchHomeTimeline(callback: (tweets: [Tweet]?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.GET(homeTimelineURL, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets: [Tweet] = []
            var tweetsArray = response as NSArray
            for tweet in tweetsArray {
                tweets.append(Tweet(dictionary: tweet as NSDictionary))
            }
            callback(tweets: tweets, error: nil)
            }) { (operations: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: \(error)")
                callback(tweets: nil, error: error)
        }
    }
    
    func sendTweet(status: NSString, inReplyToStatusId: Int?, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        var params = ["status": status]
        if (inReplyToStatusId != nil) {
            params.updateValue("\(inReplyToStatusId!)", forKey: "in_reply_to_status_id")
        }
        TwitterClient.sharedInstance.POST(statusUpdateURL, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as NSDictionary)
            callback(tweet: tweet, error: nil)
            }) { (operations: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: \(error)")
                callback(tweet: nil, error: error)
        }
    }
    
    func favouriteTweet(statusId: Int, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        var params = ["id": statusId]
        
        TwitterClient.sharedInstance.POST(favoriteURL, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as NSDictionary)
            callback(tweet: tweet, error: nil)
            }) { (operations: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: \(error)")
                callback(tweet: nil, error: error)
        }
    }

    func retweet(statusId: Int, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        var params = ["id": statusId]
        var url = "\(retweetURL)/\(statusId).json"
        
        TwitterClient.sharedInstance.POST(url, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as NSDictionary)
            callback(tweet: tweet, error: nil)
            }) { (operations: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: \(error)")
                callback(tweet: nil, error: error)
        }
    }
}
    

