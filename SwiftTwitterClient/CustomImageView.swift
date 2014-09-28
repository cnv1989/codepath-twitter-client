//
//  CustomImageView.swift
//  SwiftTwitterClient
//
//  Created by Nag Varun Chunduru on 9/28/14.
//  Copyright (c) 2014 cnv. All rights reserved.
//

import UIKit

var ImageCache =  [String : UIImage]()

class CustomImageView: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    func loadImage(urlString: NSString) {
        var image: UIImage? = nil
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            ImageCache[urlString] = image
            self.image = image;
        }
        
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequestFailure")
        }
        
        if image == nil {
            var imgURL: NSURL = NSURL(string: urlString)
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            self.setImageWithURLRequest(request, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.image = image
            })
        }
        
    }

}
