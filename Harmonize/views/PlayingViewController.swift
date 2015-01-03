//
//  PlayingViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/3/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class PlayingViewController: UIViewController {
    
    @IBOutlet var coverImage: UIImageView!
    
    @IBOutlet var sourceText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coverImage.clipsToBounds = true
        Mozart().load("https://i.scdn.co/image/50c593022e62a93b08a4b2aac3a2a3dbd458ca49").into(coverImage)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
