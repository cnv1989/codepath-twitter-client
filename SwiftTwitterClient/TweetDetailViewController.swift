//
//  TweetDetailViewController.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/28/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet!

    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    

    override func viewDidLoad() {
        self.profilePic.layer.cornerRadius = 5
        self.profilePic.clipsToBounds = true
        super.viewDidLoad()
        self.configure()

        // Do any additional setup after loading the view.
    }
    
    func configure() {
        self.profilePic.loadImage(self.tweet.user!.profile_image_url!)
        self.displayNameLabel.text = self.tweet.user!.name!
        self.screenNameLabel.text = "@\(self.tweet.user!.screen_name!)"
        self.updateDateString(self.tweet.created_at!)
        self.tweetText.text  = self.tweet.text!
        self.favoritesCountLabel.text = "\(self.tweet.favorite_count!)"
        self.retweetsCountLabel.text = "\(self.tweet.retweet_count!)"
        
        self.favoriteButton.enabled = !self.tweet.favorited!
        self.retweetButton.enabled = !self.tweet.retweeted!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onFavoriteTap(sender: AnyObject) {
        TwitterClient.sharedInstance.favouriteTweet(self.tweet.id!, callback: { (tweet, error) -> Void in
            if (tweet != nil) {
                self.favoriteButton.enabled = false
                dispatch_async(dispatch_get_main_queue(), {
                    self.tweet = tweet
                    self.configure()
                })
            } else {
                NSLog("Error: \(error)")
            }
        })
    }
    
    @IBAction func onRetweetTap(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(self.tweet.id!, callback: { (tweet, error) -> Void in
            if (tweet != nil) {
                NSNotificationCenter.defaultCenter().postNotificationName(StatusSuccessfullyUpdated, object: nil)
                self.retweetButton.enabled = false
                dispatch_async(dispatch_get_main_queue(), {
                    self.tweet = tweet
                    self.configure()
                })
            } else {
                NSLog("Error: \(error)")
            }
        })
    }

    func updateDateString(dateString: NSString) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        var date = dateFormatter.dateFromString(dateString)
        dateFormatter.dateFormat = "MMM d hh:mm a"
        self.timeLabel.text = "\(dateFormatter.stringFromDate(date!))"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "replyToTweetSegue") {
            var tweetViewController: TweetViewController = segue.destinationViewController as TweetViewController
            tweetViewController.inReplyToStatusId = self.tweet.id!
        }
    }
}
