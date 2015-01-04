//
//  HMAuthentication.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import AVFoundation
import MediaPlayer

func authenticateWithURL(url: NSURL) -> Bool {
    switch url.host! {
    case "spotify":
        return authenticateSpotifyWithURL(url)
    case "soundcloud":
        return authenticateSoundCloudWithCode(url.query!.componentsSeparatedByString("=")[1])
    default:
        println("Error authenticating service: \(url.host!)")
        return false
    }
}

let spotifyClientID = "b773cebaa2cb4c86b5e49464cd5d4f25"
let spotifyCallbackURL = "harmonize-login://spotify"
let spotifyTokenSwapURL = "http://harmonize.co:1234/swap"
let spotifyTokenRefreshURL = "http://harmonize.co:1234/refresh"
var spotifyAuthenticated = false

func authenticateSpotify() {
    let sessionString = SSKeychain.passwordForService("harmonize", account: "spotify")
    let sessionData = NSData(base64EncodedString: sessionString, options: nil)!
    let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as SPTSession
    
    SPTAuth.defaultInstance().renewSession(session, withServiceEndpointAtURL: NSURL(string: spotifyTokenRefreshURL)) { (error, session) -> Void in
        if error != nil {
            println("Auth error: \(error.localizedDescription)")
            return
        }
        
        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
        let sessionString = sessionData.base64EncodedStringWithOptions(nil)
        SSKeychain.setPassword(sessionString, forService: "harmonize", account: "spotify")
        
        spotifySession = session
        spotifyPlayer = SPTAudioStreamingController(clientId: spotifyClientID)
        
        spotifyPlayer.loginWithSession(spotifySession, callback: nil)
    }
}

func authenticateSpotifyWithURL(url: NSURL) -> Bool {
    if SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string: spotifyCallbackURL)) {
        SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: NSURL(string: spotifyTokenSwapURL), callback: { (error, session) -> Void in
            if error != nil {
                println("Auth from url error: \(error.localizedDescription)")
                return
            }
            
            let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
            let sessionString = sessionData.base64EncodedStringWithOptions(nil)
            SSKeychain.setPassword(sessionString, forService: "harmonize", account: "spotify")
            
            spotifySession = session
            spotifyPlayer = SPTAudioStreamingController(clientId: spotifyClientID)
            
            spotifyPlayer.loginWithSession(spotifySession, callback: nil)
        })
        
        spotifyAuthenticated = true
    }
    
    return spotifyAuthenticated
}

let soundCloudClientID = "baf7155dfc93f3df6428d89a64bf5a75"
let soundCloudClientSecret = "3cd41889ed08ab4eda39156c21ee539f"
let soundCloudCallbackURL = "harmonize-login://soundcloud"
var soundCloudAccessToken = ""
var soundCloudAuthenticated = false

func authenticateSoundCloud() {
    let authURL = NSURL(string: "https://api.soundcloud.com/oauth2/token")!
    let refreshToken = SSKeychain.passwordForService("harmonize", account: "soundcloud")
    let postString = "client_id=\(soundCloudClientID)&client_secret=\(soundCloudClientSecret)&grant_type=refresh_token&refresh_token=\(refreshToken)"
    let postData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    
    let request = NSMutableURLRequest(URL: authURL)
    request.HTTPMethod = "POST"
    request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
    request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = postData
    
    let returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
    
    if let resultJSON = NSJSONSerialization.JSONObjectWithData(returnData, options: .MutableContainers, error: nil) as? NSDictionary {
        if let accessToken = resultJSON["access_token"] as? String {
            if let refreshToken = resultJSON["refresh_token"] as? String {
                SSKeychain.setPassword(refreshToken, forService: "harmonize", account: "soundcloud")
                
                soundCloudAccessToken = accessToken
                soundCloudAuthenticated = true
            }
        }
    }
}

func authenticateSoundCloudWithCode(code: String) -> Bool {
    let authURL = NSURL(string: "https://api.soundcloud.com/oauth2/token")!
    let postString = "client_id=\(soundCloudClientID)&client_secret=\(soundCloudClientSecret)&grant_type=authorization_code&redirect_uri=\(soundCloudCallbackURL)&code=\(code)"
    let postData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    
    let request = NSMutableURLRequest(URL: authURL)
    request.HTTPMethod = "POST"
    request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
    request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = postData
    
    let returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
    
    if let resultJSON = NSJSONSerialization.JSONObjectWithData(returnData, options: .MutableContainers, error: nil) as? NSDictionary {
        if let accessToken = resultJSON["access_token"] as? String {
            if let refreshToken = resultJSON["refresh_token"] as? String {
                SSKeychain.setPassword(refreshToken, forService: "harmonize", account: "soundcloud")
                
                soundCloudAccessToken = accessToken
                soundCloudAuthenticated = true
            }
        }
    }
    
    return soundCloudAuthenticated
}

let rdioConsumerKey = "2cb63333mevn8gaet83g82mg"
let rdioSharedSecret = "wtcRmU4Zqr"
var rdioAuthenticated = false

func authenticateRdio() -> Bool {
    rdioPlayer = Rdio(consumerKey: rdioConsumerKey, andSecret: rdioSharedSecret, delegate: nil)
    rdioAuthenticated = true
    return rdioAuthenticated
}
