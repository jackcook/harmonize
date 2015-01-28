//
//  Mozart.swift
//  Element Animation
//
//  Created by Jack Cook on 12/7/14.
//  Copyright (c) 2014 CosmicByte. All rights reserved.
//

import UIKit

public class Mozart {
    
    public func load(url: String) -> LoadingClass {
        let loadingClass = LoadingClass()
        loadingClass.url = url
        return loadingClass
    }
}

public class LoadingClass: NSObject {
    
    var url: String!
    var completionBlock: (UIImage -> Void)!
    
    public func into(imageView: UIImageView) -> LoadingClass {
        getImage() { (image) -> Void in
            imageView.image = image
        }
        
        return self
    }
    
    public func into(button: UIButton) -> LoadingClass {
        getImage() { (image) -> Void in
            button.setImage(image, forState: UIControlState.Normal)
        }
        
        return self
    }
    
    public func into(button: UIButton, forState state: UIControlState) -> LoadingClass {
        getImage() { (image) -> Void in
            button.setImage(image, forState: state)
        }
        
        return self
    }
    
    public func completion(block: UIImage -> Void) {
        completionBlock = block
    }
    
    func getImage(block: UIImage -> Void) {
        var actualUrl = NSURL(string: url)!
        var request = NSURLRequest(URL: actualUrl)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if error == nil {
                var image = UIImage(data: data)!
                block(image)
                if (self.completionBlock != nil) {
                    self.completionBlock(image)
                }
            } else {
                println("Error: \(error.localizedDescription)")
            }
        }
    }
}
