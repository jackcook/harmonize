//
//  PlayingViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/3/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class PlayingViewController: UIViewController {
    
    @IBOutlet var coverImage: UIImageView!
    
    @IBOutlet var progressBar: UIView!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var totalTime: UILabel!
    
    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var songTitle: UILabel!
    
    @IBOutlet var sourceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverImage.clipsToBounds = true
        Mozart().load("https://i.scdn.co/image/50c593022e62a93b08a4b2aac3a2a3dbd458ca49").into(coverImage)
        
        
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
    }
    
    @IBAction func nextButton(sender: AnyObject) {
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
