//
//  BrowseViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class BrowseViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    var albumViews = [AlbumView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SPTAlbum.albumWithURI(NSURL(string: "spotify:album:2spbck4ETZz1aLq5Fi5phC"), session: spotifySession) { (error, album) -> Void in
            let albumView = AlbumView(album: album as SPTAlbum, frame: CGRectMake(0, 0, self.scrollView.frame.size.height * (13/20), self.scrollView.frame.size.height))
            
            self.scrollView.addSubview(albumView)
            
            self.albumViews.append(albumView)
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.clipsToBounds = false
        
        for albumView in albumViews {
            albumView.layer.shadowColor = UIColor.blackColor().CGColor
            albumView.layer.shadowPath = UIBezierPath(roundedRect: CGRectMake(0, 0, albumView.bounds.width, albumView.bounds.height), cornerRadius: 0).CGPath
            albumView.layer.shadowOffset = CGSizeMake(0, 0)
            albumView.layer.shadowOpacity = 0.35
            albumView.layer.shadowRadius = 4
            albumView.layer.masksToBounds = true
            albumView.clipsToBounds = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
