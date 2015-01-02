//
//  HMAuthentication.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

func authenticateWithURL(url: NSURL) -> Bool {
    switch url.host! {
    case "spotify":
        return authenticateSpotify(url)
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

func authenticateSoundCloud() {
    
}
