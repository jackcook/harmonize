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
        
        SPTTrack.trackWithURI(NSURL(string: "spotify:track:2IWw5tDMzgtUyAT4EwKAYW"), session: spotifySession) { (error, track) -> Void in
            let t = track as SPTTrack
            self.total = Int(t.duration)
            
            var mins = 0
            var secs = self.total
            
            while secs >= 60 {
                secs -= 60
                mins += 1
            }
            
            let secstr = NSString(format: "%02d", secs)
            self.totalTime.text = "\(mins):\(secstr)"
            
            self.albumTitle.text = "\(t.artists[0].name) – \(t.album.name)"
            self.songTitle.text = t.name
            Mozart().load(t.album.largestCover.imageURL.absoluteString!).into(self.coverImage)
            
            spotifyPlayer.playTrackProvider(track as SPTTrack, callback: nil)
            
            let timer = NSTimer(timeInterval: 0.25, target: self, selector: "updateTime", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
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
