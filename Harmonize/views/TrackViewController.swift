//
//  TrackViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/3/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import AVFoundation
import MediaPlayer

class TrackViewController: UIViewController, SPTAudioStreamingPlaybackDelegate {
    
    @IBOutlet var coverImage: UIImageView!
    
    @IBOutlet var progressBarLeft: NSLayoutConstraint!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var totalTime: UILabel!
    
    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var songTitle: UILabel!
    
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var sourceLabel: UILabel!
    
    var track: SPTTrack!
    var uris: [NSURL]!
    var coverArtwork: UIImage!
    
    var paused = false
    var total = 0
    
    var pbPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverImage.clipsToBounds = true
        
        updateMetadata(track)
        
        spotifyPlayer.setURIs(uris, callback: { (error) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                spotifyPlayer.queuePlay(nil)
            }
        })
        
        spotifyPlayer.playbackDelegate = self
        spotifyPlayer.setVolume(0.75, callback: nil)
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        let timer = NSTimer(timeInterval: 0.1, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    override func viewDidLayoutSubviews() {
        pbPoint = pauseButton.frame.origin
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        if event.type == .RemoteControl {
            switch event.subtype {
            case .RemoteControlPause, .RemoteControlPlay, .RemoteControlTogglePlayPause:
                pauseButtonPressed()
            default:
                println(event.subtype.rawValue)
            }
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
    
    func updateMetadata(track: SPTTrack) {
        self.total = Int(track.duration)
        
        var mins = 0
        var secs = self.total
        
        while secs >= 60 {
            secs -= 60
            mins += 1
        }
        
        let secstr = NSString(format: "%02d", secs)
        self.totalTime.text = "\(mins):\(secstr)"
        
        self.albumTitle.text = "\(track.artists[0].name) – \(track.album.name)"
        self.songTitle.text = track.name
        Mozart().load(track.album.largestCover.imageURL.absoluteString!).into(self.coverImage).completion() { (image) -> Void in
            let artwork = MPMediaItemArtwork(image: image)
            
            let nowPlayingInfo = [
                MPMediaItemPropertyArtist: track.artists[0].name,
                MPMediaItemPropertyTitle: track.name,
                MPMediaItemPropertyPlaybackDuration: track.duration,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: spotifyPlayer.currentPlaybackPosition,
                MPMediaItemPropertyArtwork: artwork
            ]
            
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
        spotifyPlayer.repeat = true
    }
    
    @IBAction func previousButton(sender: AnyObject) {
        spotifyPlayer.skipPrevious { (error) -> Void in
            let trackURI = spotifyPlayer.currentTrackMetadata[SPTAudioStreamingMetadataTrackURI] as String
            SPTTrack.trackWithURI(NSURL(string: trackURI), session: spotifySession, callback: { (error, track) -> Void in
                self.updateMetadata(track as SPTTrack)
            })
        }
    }
    
    @IBAction func pauseButtonPressed() {
        pauseButton.setImage(paused ? UIImage(named: "image08.png") : UIImage(named: "image09.png"), forState: .Normal)
        pauseButton.frame = CGRectMake(pauseButton.frame.origin.x, pauseButton.frame.origin.y, (paused ? (74/99) : (90/103)) * pauseButton.frame.size.height, pauseButton.frame.size.height)
        pauseButton.center = pbPoint
        
        spotifyPlayer.setIsPlaying(paused ? true : false, callback: nil)
        paused = !paused
    }
    
    @IBAction func nextButtonPressed() {
        spotifyPlayer.skipNext { (error) -> Void in
            let trackURI = spotifyPlayer.currentTrackMetadata[SPTAudioStreamingMetadataTrackURI] as String
            SPTTrack.trackWithURI(NSURL(string: trackURI), session: spotifySession, callback: { (error, track) -> Void in
                self.updateMetadata(track as SPTTrack)
            })
        }
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: NSURL!) {
        SPTTrack.trackWithURI(trackUri, session: spotifySession) { (error, t) -> Void in
            let track = t as SPTTrack
            self.updateMetadata(track)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
