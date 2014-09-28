//
//  TweetTableViewCell.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/27/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit


class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.profilePic.layer.cornerRadius = 5
        self.profilePic.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(tweet: Tweet) {
        self.nameLabel?.text = "\(tweet.user!.name!)"
        self.screenNameLabel?.text = "@\(tweet.user!.screen_name!)"
        self.profilePic.loadImage("\(tweet.user!.profile_image_url!)")
        self.tweetTextLabel?.text = "\(tweet.text!)"
        self.updateDateString(tweet.created_at!)
        self.tweetTextLabel.sizeToFit()
    }
    
    func updateDateString(dateString: NSString) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        var date = dateFormatter.dateFromString(dateString)
        dateFormatter.dateFormat = "MMM d"
        self.dateLabel.text = "\(dateFormatter.stringFromDate(date!))"
    }

}
