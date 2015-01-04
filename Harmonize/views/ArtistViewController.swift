//
//  ArtistViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/4/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class ArtistViewController: UIViewController {
    
    @IBOutlet var artistImage: UIImageView!
    @IBOutlet var artistName: UILabel!
    @IBOutlet var artistFollowers: UILabel!
    
    var laidOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SPTArtist.artistWithURI(NSURL(string: "spotify:artist:0Ye4nfYAA91T1X56gnlXAA"), session: spotifySession) { (error, artist) -> Void in
            var a = artist as SPTArtist
            Mozart().load(a.largestImage.imageURL.absoluteString!).into(self.artistImage)
            self.artistName.text = a.name
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            let numstr = formatter.stringFromNumber(a.followerCount)!.stringByReplacingOccurrencesOfString(",", withString: " ")
            
            self.artistFollowers.text = "\(numstr) Followers"
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !laidOut {
            laidOut = true
            
            var gradient = CAGradientLayer()
            gradient.frame = artistImage.bounds
            gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.6).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.9).CGColor]
            artistImage.layer.insertSublayer(gradient, atIndex: 0)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
