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
        /*let spotifyAuth = SPTAuth.defaultInstance()
        spotifyLoginURL = spotifyAuth.loginURLForClientId(spotifyClientID, declaredRedirectURL: NSURL(string: spotifyCallbackURL), scopes: [SPTAuthStreamingScope])
        
        var timer = NSTimer(timeInterval: 0.1, target: self, selector: "spotifyLogin", userInfo: nil, repeats: true)
        timer.fire()*/
        
        /*soundCloudLoginURL = NSURL(string: "https://soundcloud.com/connect?client_id=\(soundCloudClientID)&response_type=code&redirect_uri=\(soundCloudCallbackURL)")
        
        var timer = NSTimer(timeInterval: 0.1, target: self, selector: "soundCloudLogin", userInfo: nil, repeats: true)
        timer.fire()*/
        
        authenticateRdio()
        
        return true
    }
    
    func spotifyLogin() {
        UIApplication.sharedApplication().openURL(spotifyLoginURL)
    }
    
    func soundCloudLogin() {
        UIApplication.sharedApplication().openURL(soundCloudLoginURL)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if url.scheme == "harmonize-login" {
            return authenticateWithURL(url)
        }
        
        return false
    }
}
