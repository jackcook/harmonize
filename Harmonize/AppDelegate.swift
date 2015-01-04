//
//  AppDelegate.swift
//  Harmonize
//
//  Created by Jack Cook on 1/1/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var spotifyLoginURL: NSURL!
    var soundCloudLoginURL: NSURL!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Flurry.startSession("XMFH35N6SFV5CV97G7FD")
        
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if url.scheme == "harmonize-login" {
            return authenticateWithURL(url)
        }
        
        return false
    }
}
