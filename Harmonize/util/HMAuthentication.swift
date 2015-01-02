//
//  HMAuthentication.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import AVFoundation

func authenticateWithURL(url: NSURL) -> Bool {
    switch url.host! {
    case "spotify":
        return authenticateSpotify(url)
    case "soundcloud":
        return authenticateSoundCloud(url.query!.componentsSeparatedByString("=")[1])
    default:
        println("Error authenticating service: \(url.host!)")
        return false
    }
}

let spotifyClientID = "b773cebaa2cb4c86b5e49464cd5d4f25"
let spotifyCallbackURL = "harmonize-login://callback"
let spotifyTokenSwapURL = "http://harmonize.co:1234/swap"

func authenticateSpotify(url: NSURL) -> Bool {
    if SPTAuth.defaultInstance().canHandleURL(url, withDeclaredRedirectURL: NSURL(string: spotifyCallbackURL)) {
        SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, tokenSwapServiceEndpointAtURL: NSURL(string: spotifyTokenSwapURL), callback: { (error, session) -> Void in
            if error != nil {
                println("Auth error: \(error.localizedDescription)")
                return
            }
            
            println("Spotify authenticated successfully!")
        })
        
        return true
    }
    
    return false
}

let soundCloudClientID = "baf7155dfc93f3df6428d89a64bf5a75"
let soundCloudClientSecret = "3cd41889ed08ab4eda39156c21ee539f"
let soundCloudCallbackURL = "harmonize-login://soundcloud"
var soundCloudOAuthToken = ""

func authenticateSoundCloud(code: String) -> Bool {
    let authURL = NSURL(string: "https://api.soundcloud.com/oauth2/token")
    let postString = "client_id=\(soundCloudClientID)&client_secret=\(soundCloudClientSecret)&grant_type=authorization_code&redirect_uri=\(soundCloudCallbackURL)&code=\(code)"
    let postData = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
    
    let request = NSMutableURLRequest(URL: authURL!)
    request.HTTPMethod = "POST"
    request.setValue("\(postData!.length)", forHTTPHeaderField: "Content-Length")
    request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
    request.HTTPBody = postData
    
    let returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
    
    if let resultJSON = NSJSONSerialization.JSONObjectWithData(returnData, options: .MutableContainers, error: nil) as? NSDictionary {
        if let accessToken = resultJSON["access_token"] as? String {
            soundCloudOAuthToken = accessToken
            downloadTrackData(70381879)
        }
    }
    
    return false
}

var player: AVAudioPlayer!

func downloadTrackData(trackID: Int) {
    let contentURL = NSURL(string: "https://api.soundcloud.com/tracks/\(trackID)/stream?client_id=\(soundCloudClientID)")!
    let data = NSData(contentsOfURL: contentURL)!
    
    player = AVAudioPlayer(data: data, error: nil)
    player.prepareToPlay()
    player.play()
}
