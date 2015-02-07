//
//  BrowseViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/7/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    
    var albumViews = [AlbumView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = self.view.backgroundColor
        tableView.contentInset = UIEdgeInsetsZero
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "SongCell")
        
        cell.backgroundColor = self.view.backgroundColor
        
        var backView = UIView(frame: cell.frame)
        backView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        cell.selectedBackgroundView = backView
        
        var numLabel = UILabel()
        numLabel.text = "\(indexPath.row + 1)"
        numLabel.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        numLabel.font = UIFont(name: "Avenir-Light", size: 14)
        numLabel.sizeToFit()
        numLabel.frame = CGRectMake(12, (48 - numLabel.frame.size.height) / 2, numLabel.frame.size.width, numLabel.frame.size.height)
        
        var nameLabel = UILabel()
        //nameLabel.text = indexPath.section == 0 ? topTracks[indexPath.row].name : albums[indexPath.row].name
        nameLabel.text = "Testing"
        nameLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        nameLabel.font = UIFont(name: "Avenir-Light", size: 14)
        nameLabel.sizeToFit()
        nameLabel.frame = CGRectMake(38, (48 - nameLabel.frame.size.height) / 2, nameLabel.frame.size.width, nameLabel.frame.size.height)
        
        var timeLabel = UILabel()
        //timeLabel.text = indexPath.section == 0 ? "\(Int(topTracks[indexPath.row].duration))" : "\(albums[indexPath.row].firstTrackPage.items.count) Songs"
        timeLabel.text = "8:00"
        timeLabel.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        timeLabel.font = UIFont(name: "Avenir-Light", size: 14)
        
//        if indexPath.section == 0 {
//            var mins = 0
//            var secs = Int(topTracks[indexPath.row].duration)
//            
//            while secs >= 60 {
//                secs -= 60
//                mins += 1
//            }
//            
//            let secstr = NSString(format: "%02d", secs)
//            timeLabel.text = "\(mins):\(secstr)"
//        }
        
        timeLabel.sizeToFit()
        timeLabel.frame = CGRectMake(tableView.bounds.size.width - timeLabel.frame.size.width - 12, (48 - timeLabel.frame.size.height) / 2, timeLabel.frame.size.width, timeLabel.frame.size.height)
        
        nameLabel.frame.size.width = timeLabel.frame.origin.x - nameLabel.frame.origin.x - 16
        
        cell.addSubview(numLabel)
        cell.addSubview(nameLabel)
        cell.addSubview(timeLabel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        uriToSend = searchResults[indexPath.row].uri
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        self.performSegueWithIdentifier("artistSegue", sender: self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
