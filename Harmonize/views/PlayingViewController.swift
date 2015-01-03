//
//  PlayingViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/3/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class PlayingViewController: UIViewController {
    
    @IBOutlet var coverImage: UIImageView!
    
    @IBOutlet var progressBarLeft: NSLayoutConstraint!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var totalTime: UILabel!
    
    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var songTitle: UILabel!
    
    @IBOutlet var sourceLabel: UILabel!
    
    var paused = false
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverImage.clipsToBounds = true
        Mozart().load("https://i.scdn.co/image/3b0db511855bc991cb3c95ea25825762fae8c114").into(coverImage)
        
        SPTTrack.trackWithURI(NSURL(string: "spotify:track:6kIpxmFQ35wgI3cK77LKbx"), session: spotifySession) { (error, track) -> Void in
            let t = track as SPTTrack
            self.total = Int(t.duration)
            self.albumTitle.text = t.artists[0].name
            self.songTitle.text = t.name
            Mozart().load(t.album.largestCover.imageURL!.absoluteString!).into(self.coverImage)
        }
        
        let timer = NSTimer(timeInterval: 1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        //NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }

    func updateTime() {
        let width = (deviceSize.width / CGFloat(total)) * CGFloat(spotifyPlayer.currentPlaybackPosition)
        
        progressBarLeft.constant = width
        
        var mins = 0
        var secs = Int(spotifyPlayer.currentPlaybackPosition)
        
        while secs >= 60 {
            secs -= 60
            mins += 1
        }
        
        let secstr = NSString(format: "%02d", secs)
        currentTime.text = "\(mins):\(secstr)"
    }
    
    @IBAction func backButton(sender: AnyObject) {
    }
    
    @IBAction func optionsButton(sender: AnyObject) {
    }
    
    @IBAction func likeButton(sender: AnyObject) {
    }
    
    @IBAction func dislikeButton(sender: AnyObject) {
    }
    
    @IBAction func shuffleButton(sender: AnyObject) {
    }
    
    @IBAction func repeatButton(sender: AnyObject) {
    }
    
    @IBAction func previousButton(sender: AnyObject) {
    }
    
    @IBAction func pauseButton(sender: AnyObject) {
        spotifyPlayer.setIsPlaying(paused ? true : false, callback: nil)
        paused = !paused
    }
    
    @IBAction func nextButton(sender: AnyObject) {
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
