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
    
    var loginURL: NSURL?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let auth = SPTAuth.defaultInstance()
        loginURL = auth.loginURLForClientId(spotifyClientID, declaredRedirectURL: NSURL(string: spotifyCallbackURL), scopes: [SPTAuthStreamingScope])
        
        var timer = NSTimer(timeInterval: 0.1, target: self, selector: "spotifyLogin", userInfo: nil, repeats: true)
        timer.fire()
        
        return true
    }
    
    func spotifyLogin() {
        UIApplication.sharedApplication().openURL(loginURL!)
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string: spotifyCallbackURL)) {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: NSURL(string: spotifyTokenSwapURL), callback: { (error, session) -> Void in
                if error != nil {
                    println("Auth error: \(error.localizedDescription)")
                    return
                }
                
                self.playUsingSession(session)
            })
            
            return true
        }
        
        return false
    }
    
    func playUsingSession(session: SPTSession) {
        if spotifyPlayer == nil {
            spotifyPlayer = SPTAudioStreamingController(clientId: spotifyClientID)
        }
        
        spotifyPlayer.loginWithSession(session, callback: { (error) -> Void in
            if error != nil {
                println("Enabling playback got error: \(error.localizedDescription)")
                return
            }
            
            SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), withSession: nil, callback: { (error, album) -> Void in
                if error != nil {
                    println("Album lookup got error: \(error.localizedDescription)")
                }
                
                spotifyPlayer.playTrackProvider(album as SPTTrackProvider, callback: nil)
            })
        })
    }
}
