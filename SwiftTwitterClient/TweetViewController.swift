//
//  TweetViewController.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/28/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

let StatusSuccessfullyUpdated = "StatusSuccessfullyUpdated"

class TweetViewController: UIViewController, UITextViewDelegate {
    
    var count = 140
    var user: User!
    var inReplyToStatusId: Int?
    
    @IBOutlet weak var profilePic: CustomImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var screenNameLabel: UILabel!

    override func viewDidLoad() {
        self.profilePic.layer.cornerRadius = 5
        self.profilePic.clipsToBounds = true
        self.user = Account.currentAccount?.user
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardDidShowNotification, object: nil, queue: nil) { (notification: NSNotification!) -> Void in
            self.keyboardDidShow(notification)
        }
        super.viewDidLoad()
        self.configure()
    }
    
    func configure() {
        self.screenNameLabel?.text = "@\(user.screen_name!)"
        self.profilePic.loadImage(user.profile_image_url!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardDidShow(notification: NSNotification) {
        var info = notification.userInfo! as NSDictionary
        let frame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        self.view.frame.size.height -= frame.size.height
    }
    
    func textViewDidChange(textView: UITextView) {
        self.count = 140 - countElements(textView.text)
        self.countLabel.text = "\(self.count)"
        if (self.count <= 0) {
            textView.editable = false
        } else {
            textView.editable = true
        }
    }

    @IBAction func composeTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        TwitterClient.sharedInstance.sendTweet(self.textArea.text, inReplyToStatusId: inReplyToStatusId,callback: { (tweet, error) -> Void in
            if (tweet != nil) {
                NSNotificationCenter.defaultCenter().postNotificationName(StatusSuccessfullyUpdated, object: nil)
            }
        })
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
