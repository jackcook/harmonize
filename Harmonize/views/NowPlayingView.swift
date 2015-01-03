//
//  NowPlayingView.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class NowPlayingView: UIView {
    
    var topBar: UIImageView!
    var backButton: UIButton!
    var nowPlayingText: UILabel!
    var optionsButton: UIButton!
    
    var coverImage: UIImageView!
    var timelineBackground: UIView!
    var timelineProgress: UIView!
    
    var currentText: UILabel!
    var durationText: UILabel!
    var albumName: UILabel!
    var trackName: UILabel!
    
    var likeButton: UIButton!
    var dislikeButton: UIButton!
    var shuffleButton: UIButton!
    var repeatButton: UIButton!
    
    var previousButton: UIButton!
    var nextButton: UIButton!
    var pauseButton: UIButton!
    
    var sourceText: UILabel!
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        topBar = UIImageView(frame: CGRectMake(0, 0, deviceSize.width, deviceSize.width / (1242 / 212)))
        topBar.image = UIImage(named: "image04.png")
        
        let backImage = UIImage(named: "image05.png")
        let backX = (topBar.frame.size.height - (backImage!.size.height / 3)) / 2
        backButton = UIButton(frame: CGRectMake(backX + 4, backX, backImage!.size.width / 3, backImage!.size.height / 3))
        backButton.setImage(backImage, forState: .Normal)
        
        nowPlayingText = UILabel()
        nowPlayingText.text = "NOW PLAYING"
        nowPlayingText.textColor = UIColor(red: 0.66, green: 0.66, blue: 0.66, alpha: 1)
        nowPlayingText.font = UIFont(name: "AppleSDGothicNeo-Light", size: 17)
        nowPlayingText.sizeToFit()
        nowPlayingText.frame = CGRectMake((topBar.frame.size.width - nowPlayingText.frame.size.width) / 2, (topBar.frame.size.height - nowPlayingText.frame.size.height) / 2, nowPlayingText.frame.size.width, nowPlayingText.frame.size.height)
        
        let optionsImage = UIImage(named: "image06.png")
        let optionsY = (topBar.frame.size.height - (optionsImage!.size.height / 3)) / 2
        let optionsX = topBar.frame.size.width - (optionsImage!.size.width / 3) - optionsY
        optionsButton = UIButton(frame: CGRectMake(optionsX - 4, optionsY, optionsImage!.size.width / 3, optionsImage!.size.height / 3))
        optionsButton.setImage(optionsImage, forState: .Normal)
        
        topBar.addSubview(backButton)
        topBar.addSubview(nowPlayingText)
        topBar.addSubview(optionsButton)
        
        coverImage = UIImageView(frame: CGRectMake(0, topBar.frame.size.height - 4, deviceSize.width, deviceSize.width))
        Mozart().load("https://i.scdn.co/image/50c593022e62a93b08a4b2aac3a2a3dbd458ca49").into(coverImage)
        
        timelineBackground = UIView(frame: CGRectMake(0, coverImage.frame.origin.y + coverImage.frame.size.height, deviceSize.width, 13))
        timelineBackground.backgroundColor = UIColor(red: 0.91, green: 0.3, blue: 0.24, alpha: 1)
        
        timelineProgress = UIView(frame: CGRectMake(127, coverImage.frame.origin.y + coverImage.frame.size.height + 2, deviceSize.width - 127, 9))
        timelineProgress.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        currentText = UILabel()
        currentText.text = "1:33"
        currentText.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        currentText.font = UIFont(name: "Avenir-Light", size: 14)
        currentText.sizeToFit()
        currentText.frame = CGRectMake(16, timelineProgress.frame.origin.y + timelineProgress.frame.size.height + 20, currentText.frame.size.width, currentText.frame.size.height)
        
        durationText = UILabel()
        durationText.text = "2:56"
        durationText.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        durationText.font = UIFont(name: "Avenir-Light", size: 14)
        durationText.sizeToFit()
        durationText.frame = CGRectMake(deviceSize.width - durationText.frame.size.width - 16, timelineProgress.frame.origin.y + timelineProgress.frame.size.height + 20, durationText.frame.size.width, durationText.frame.size.height)
        
        albumName = UILabel()
        albumName.text = "Mako - Single"
        albumName.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        albumName.font = UIFont(name: "Avenir-Light", size: 15)
        albumName.sizeToFit()
        albumName.frame = CGRectMake((deviceSize.width - albumName.frame.size.width) / 2, timelineProgress.frame.origin.y + timelineProgress.frame.size.height + 20, albumName.frame.size.width, albumName.frame.size.height)
        
        trackName = UILabel()
        trackName.text = "Sunburst"
        trackName.textColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
        trackName.font = UIFont(name: "Avenir-Light", size: 19)
        trackName.sizeToFit()
        trackName.frame = CGRectMake((deviceSize.width - trackName.frame.size.width) / 2, albumName.frame.origin.y + albumName.frame.size.height + 2, trackName.frame.size.width, trackName.frame.size.height)
        
        let likeImage = UIImage(named: "image11.png")
        likeButton = UIButton(frame: CGRectMake(22, trackName.frame.origin.y + trackName.frame.size.height + 20, likeImage!.size.width / 3.5, likeImage!.size.height / 3.5))
        likeButton.setImage(likeImage, forState: .Normal)
        
        let dislikeImage = UIImage(named: "image12.png")
        dislikeButton = UIButton(frame: CGRectMake(deviceSize.width - (dislikeImage!.size.width / 3.5) - 22, trackName.frame.origin.y + trackName.frame.size.height + 20, dislikeImage!.size.width / 3.5, dislikeImage!.size.height / 3.5))
        dislikeButton.setImage(dislikeImage, forState: .Normal)
        
        let shuffleImage = UIImage(named: "image13.png")
        shuffleButton = UIButton(frame: CGRectMake(26, likeButton.frame.origin.y + likeButton.frame.size.height + 16, shuffleImage!.size.width / 3.25, shuffleImage!.size.height / 3.25))
        shuffleButton.setImage(shuffleImage, forState: .Normal)
        
        let repeatImage = UIImage(named: "image14.png")
        repeatButton = UIButton(frame: CGRectMake(deviceSize.width - (repeatImage!.size.width / 3.25) - 26, dislikeButton.frame.origin.y + dislikeButton.frame.size.height + 16, repeatImage!.size.width / 3.25, repeatImage!.size.height / 3.25))
        repeatButton.setImage(repeatImage, forState: .Normal)
        
        let previousImage = UIImage(named: "image07.png")
        previousButton = UIButton(frame: CGRectMake(likeButton.frame.origin.x + likeButton.frame.size.width + (deviceSize.width / 10), trackName.frame.origin.y + trackName.frame.size.height + 38, previousImage!.size.width / 3.25, previousImage!.size.height / 3.25))
        previousButton.setImage(previousImage, forState: .Normal)
        
        let nextImage = UIImage(named: "image10.png")
        nextButton = UIButton(frame: CGRectMake(dislikeButton.frame.origin.x - (nextImage!.size.width / 3.25) - (deviceSize.width / 10), trackName.frame.origin.y + trackName.frame.size.height + 38, nextImage!.size.width / 3.25, nextImage!.size.height / 3.25))
        nextButton.setImage(nextImage, forState: .Normal)
        
        let pauseImage = UIImage(named: "image08.png")
        pauseButton = UIButton(frame: CGRectMake((deviceSize.width - (pauseImage!.size.width / 3.25)) / 2, trackName.frame.origin.y + trackName.frame.size.height + 34, pauseImage!.size.width / 3.25, pauseImage!.size.height / 3.25))
        pauseButton.setImage(pauseImage, forState: .Normal)
        pauseButton.addTarget(self, action: "pauseButtonAction", forControlEvents: .TouchUpInside)
        
        sourceText = UILabel(frame: CGRectMake(16, pauseButton.frame.origin.y + pauseButton.frame.size.height + ((deviceSize.height - pauseButton.frame.origin.y - pauseButton.frame.size.height - 24) / 2), deviceSize.width - 32, 24))
        sourceText.text = "Provided by Spotify"
        sourceText.textColor = UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1)
        sourceText.textAlignment = .Center
        sourceText.font = UIFont(name: "AppleSDGothicNeo-Light", size: 13)
        
        self.addSubview(topBar)
        self.addSubview(coverImage)
        self.addSubview(timelineBackground)
        self.addSubview(timelineProgress)
        self.addSubview(currentText)
        self.addSubview(durationText)
        self.addSubview(albumName)
        self.addSubview(trackName)
        self.addSubview(likeButton)
        self.addSubview(dislikeButton)
        self.addSubview(shuffleButton)
        self.addSubview(repeatButton)
        self.addSubview(previousButton)
        self.addSubview(nextButton)
        self.addSubview(pauseButton)
        self.addSubview(sourceText)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pauseButtonAction() {
        if spotifyAuthenticated {
            SPTRequest.requestItemAtURI(NSURL(string: "spotify:track:3XWZ7PNB3ei50bTPzHhqA6"), withSession: spotifySession) { (error, track) -> Void in
                spotifyPlayer.playTrackProvider(track as SPTTrack, callback: nil)
            }
        }
    }
}
