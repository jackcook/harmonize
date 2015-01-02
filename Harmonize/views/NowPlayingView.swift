//
//  NowPlayingView.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class NowPlayingView: UIView {
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if spotifyAuthenticated {
            SPTRequest.requestItemAtURI(NSURL(string: "spotify:track:2IWw5tDMzgtUyAT4EwKAYW"), withSession: spotifySession) { (error, track) -> Void in
                spotifyPlayer.playTrackProvider(track as SPTTrack, callback: nil)
            }
        }
    }
}
