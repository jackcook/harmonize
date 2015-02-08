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
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var shuffleButton: UIButton!
    @IBOutlet var repeatButton: UIButton!
    
    var uris: [NSURL]!
    var currentURI = 0
    
    var currentTrack: SPTTrack!
    var coverArtwork: MPMediaItemArtwork!
    
    var repeat = false
    var shuffle = false
    
    var invalidateNextStop = false
    
    var paused = false
    var total = 0
    
    var pbPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverImage.clipsToBounds = true
        
        updateMetadata(uris[currentURI])
        
        /*spotifyPlayer.setURIs(uris, callback: { (error) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                spotifyPlayer.queuePlay(nil)
            }
        })*/
        
        spotifyPlayer.playURI(uris[currentURI], callback: nil)
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
            case .RemoteControlNextTrack:
                nextButtonPressed()
            case .RemoteControlPreviousTrack:
                previousButtonPressed()
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
        
        if let ca = coverArtwork {
            let nowPlayingInfo = [
                MPMediaItemPropertyArtist: currentTrack.artists[0].name,
                MPMediaItemPropertyTitle: currentTrack.name,
                MPMediaItemPropertyPlaybackDuration: currentTrack.duration,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: spotifyPlayer.currentPlaybackPosition,
                MPMediaItemPropertyArtwork: coverArtwork
            ]
            
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
        } else {
            let nowPlayingInfo = [
                MPMediaItemPropertyArtist: currentTrack.artists[0].name,
                MPMediaItemPropertyTitle: currentTrack.name,
                MPMediaItemPropertyPlaybackDuration: currentTrack.duration,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: spotifyPlayer.currentPlaybackPosition
            ]
            
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    func updateMetadata(uri: NSURL) {
        SPTTrack.trackWithURI(uri, session: spotifySession) { (error, t) -> Void in
            let track = t as SPTTrack
            self.currentTrack = track
            
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
                self.coverArtwork = MPMediaItemArtwork(image: image)
            }
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func optionsButton(sender: AnyObject) {
    }
    
    @IBAction func likeButtonPressed() {
    }
    
    @IBAction func dislikeButtonPressed() {
    }
    
    @IBAction func shuffleButtonPressed() {
        shuffle = !shuffle
        shuffleButton.setImage(shuffle ? UIImage(named: "image23.png") : UIImage(named: "image13.png"), forState: .Normal)
    }
    
    @IBAction func repeatButtonPressed() {
        repeat = !repeat
        repeatButton.setImage(repeat ? UIImage(named: "image24.png") : UIImage(named: "image14.png"), forState: .Normal)
    }
    
    @IBAction func previousButtonPressed() {
        if currentURI > 0 {
            invalidateNextStop = true
            
            currentURI -= 1
            updateMetadata(uris[currentURI])
            spotifyPlayer.playURI(uris[currentURI], callback: nil)
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
        if currentURI < uris.count - 1 {
            invalidateNextStop = true
            
            currentURI += 1
            updateMetadata(uris[currentURI])
            spotifyPlayer.playURI(uris[currentURI], callback: nil)
        }
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: NSURL!) {
        if !invalidateNextStop {
            if repeat {
                spotifyPlayer.playURI(uris[currentURI], callback: nil)
            } else {
                if shuffle {
                    var newURI = Int(arc4random_uniform(UInt32(uris.count)))
                    
                    while newURI == currentURI {
                        newURI = Int(arc4random_uniform(UInt32(uris.count)))
                    }
                    
                    currentURI = newURI
                    updateMetadata(uris[currentURI])
                    spotifyPlayer.playURI(uris[currentURI], callback: nil)
                } else {
                    nextButtonPressed()
                }
            }
        } else {
            invalidateNextStop = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
