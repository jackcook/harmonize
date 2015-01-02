//
//  NowPlayingView.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class NowPlayingView: UIView {
    
    var a: UIImageView!
    var b: UILabel!
    var c: UILabel!
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        a = UIImageView(frame: CGRectMake(136, 183, 300, 300))
        
        b = UILabel(frame: CGRectMake(194, 524, 350, 50))
        b.text = "playing now wowowowow"
        
        c = UILabel(frame: CGRectMake(34, 300, 250, 50))
        c.text = "Avicii"
        
        self.addSubview(a)
        self.addSubview(b)
        self.addSubview(c)
        
        Mozart().load("https://i.scdn.co/image/9a8686f673072b38fee12b742d4460907ebc6f08").into(a)
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
