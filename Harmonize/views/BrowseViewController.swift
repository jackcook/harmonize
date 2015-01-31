//
//  BrowseViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class BrowseViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textField: UITextField!
    
    var albumViews = [AlbumView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*HMRequest.requestFeaturedAlbums() { (albums) -> Void in
            for album in albums {
                let albumView = AlbumView(album: album, frame: CGRectMake(self.albumViews.count == 0 ? 0 : ((self.albumViews[0].frame.size.width + 16) * CGFloat(self.albumViews.count)), 0, (self.scrollView.frame.size.height) * (13/20), self.scrollView.frame.size.height))
                
                self.scrollView.addSubview(albumView)
                self.albumViews.append(albumView)
            }
        }*/
        
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as String
        
        SPTRequest.requestNewReleasesForCountry(countryCode, limit: 6, offset: 0, session: spotifySession) { (error, listPage) -> Void in
            if error != nil {
                println("\(error.localizedDescription)")
            }
            
            let lp = listPage as SPTListPage
            
            for partialAlbum in lp.items {
                let pa = partialAlbum as SPTPartialAlbum
                SPTRequest.requestItemFromPartialObject(pa, withSession: spotifySession, callback: { (error, album) -> Void in
                    if error != nil {
                        println("\(error.localizedDescription)")
                    } else {
                        let a = album as SPTAlbum
                        
                        let albumView = AlbumView(album: a, frame: CGRectMake(self.albumViews.count == 0 ? 0 : ((self.albumViews[0].frame.size.width + 16) * CGFloat(self.albumViews.count)), 0, (self.scrollView.frame.size.height) * (13/20), self.scrollView.frame.size.height))
                        
                        self.scrollView.addSubview(albumView)
                        self.albumViews.append(albumView)
                    }
                    
                    self.scrollView.contentSize = CGSizeMake(self.scrollView.subviews[self.scrollView.subviews.count - 1].frame.origin.x + self.scrollView.subviews[self.scrollView.subviews.count - 1].frame.size.width, self.scrollView.frame.size.height)
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        for albumView in albumViews {
            albumView.layer.shadowColor = UIColor.blackColor().CGColor
            albumView.layer.shadowPath = UIBezierPath(roundedRect: CGRectMake(0, 0, albumView.bounds.width, albumView.bounds.height), cornerRadius: 0).CGPath
            albumView.layer.shadowOffset = CGSizeMake(0, 0)
            albumView.layer.shadowOpacity = 0.35
            albumView.layer.shadowRadius = 4
            albumView.layer.masksToBounds = true
            albumView.clipsToBounds = false
            
            scrollView.clipsToBounds = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let svc = segue.destinationViewController as SearchViewController
        svc.searchTerm = textField.text
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
