//
//  TweetsTableViewController.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/27/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController {
    
    var tweets: [Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view as UITableView).estimatedRowHeight = 200
        (self.view as UITableView).rowHeight = UITableViewAutomaticDimension
        NSNotificationCenter.defaultCenter().addObserverForName(StatusSuccessfullyUpdated, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            self.fetchHomeTimeline()
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Checking for Updates")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh(sender: AnyObject?) {
        self.fetchHomeTimeline()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.fetchHomeTimeline()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tweets.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as TweetTableViewCell
        let tweet = self.tweets[indexPath.row]
        cell.configure(tweet)
        return cell
    }
    
    func fetchHomeTimeline() {
        TwitterClient.sharedInstance.fetchHomeTimeline { (tweets, error) -> Void in
            if (tweets != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tweets = tweets!
                    (self.view as UITableView).reloadData()
                    self.refreshControl!.endRefreshing()
                })
            } else {
                NSLog("Error: \(error)") 
                self.refreshControl!.endRefreshing()
            }
        }
    }
    @IBAction func onLogoutTap(sender: AnyObject) {
        Account.currentAccount?.logout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTweetDetailsSegue") {
            var index = (self.view as UITableView).indexPathForSelectedRow()?.row
            var tweet = tweets[index!]
            var tweetDetailViewController: TweetDetailViewController = segue.destinationViewController as TweetDetailViewController
            tweetDetailViewController.tweet = tweet
        }
    }
}
