//
//  ViewController.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/26/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginTap(sender: AnyObject) {
        TwitterClient.sharedInstance.login { (account, error) -> Void in
            if (account != nil) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                NSLog("Error: \(error)")
            }
        }
    }

}

