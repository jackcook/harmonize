//
//  ArtistViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/4/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class ArtistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var artistImage: UIImageView!
    @IBOutlet var artistName: UILabel!
    @IBOutlet var artistFollowers: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var headerTitles = ["Top Tracks", "Albums"]
    var topTracks: [SPTTrack]!
    var albums: [SPTAlbum]!
    
    var topTracksDone = false
    var albumsDone = false
    
    var laidOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistImage.clipsToBounds = true
        
        tableView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.height, 12))
        
        albums = [SPTAlbum]()
        
        SPTArtist.artistWithURI(NSURL(string: "spotify:artist:1vCWHaC5f2uS3yhpwWbIA6"), session: spotifySession) { (error, artist) -> Void in
            let a = artist as SPTArtist
            Mozart().load(a.largestImage.imageURL.absoluteString!).into(self.artistImage)
            self.artistName.text = a.name
            
            let formatter = NSNumberFormatter()
            formatter.numberStyle = .DecimalStyle
            let numstr = formatter.stringFromNumber(a.followerCount)!.stringByReplacingOccurrencesOfString(",", withString: " ")
            
            self.artistFollowers.text = "\(numstr) Followers"
            
            let locale = NSLocale.currentLocale()
            let countryCode = locale.objectForKey(NSLocaleCountryCode) as String
            println("\(countryCode)")
            
            a.requestTopTracksForTerritory(countryCode, withSession: spotifySession, callback: { (error, tracks) -> Void in
                self.topTracks = tracks as [SPTTrack]
                self.topTracksDone = true
                
                if self.albumsDone {
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    
                    self.tableView.reloadData()
                }
            })
            
            a.requestAlbumsOfType(SPTAlbumType.Album, withSession: spotifySession, availableInTerritory: countryCode, callback: { (error, listPage) -> Void in
                let lp = listPage as SPTListPage
                
                for album in lp.items as [SPTPartialAlbum] {
                    SPTRequest.requestItemFromPartialObject(album, withSession: spotifySession, callback: { (error, fullAlbum) -> Void in
                        self.albums.append(fullAlbum as SPTAlbum)
                        
                        if self.albums.count == lp.items.count {
                            self.albumsDone = true
                            
                            if self.topTracksDone {
                                self.tableView.delegate = self
                                self.tableView.dataSource = self
                                
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        if !laidOut {
            laidOut = true
            
            var gradient = CAGradientLayer()
            gradient.frame = artistImage.bounds
            gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.75).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.95).CGColor]
            artistImage.layer.insertSublayer(gradient, atIndex: 0)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? topTracks.count : albums.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 48))
        header.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        var title = UILabel()
        title.text = headerTitles[section]
        title.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
        title.font = UIFont(name: "Avenir-Light", size: 14)
        title.sizeToFit()
        title.frame = CGRectMake(38, (36 - title.frame.size.height) / 2, title.frame.size.width, title.frame.size.height)
        
        header.addSubview(title)
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "SongCell")
        
        cell.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        var numLabel = UILabel()
        numLabel.text = "\(indexPath.row + 1)"
        numLabel.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        numLabel.font = UIFont(name: "Avenir-Light", size: 14)
        numLabel.sizeToFit()
        numLabel.frame = CGRectMake(38, (48 - numLabel.frame.size.height) / 2, numLabel.frame.size.width, numLabel.frame.size.height)
        
        var nameLabel = UILabel()
        nameLabel.text = indexPath.section == 0 ? topTracks[indexPath.row].name : albums[indexPath.row].name
        nameLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        nameLabel.font = UIFont(name: "Avenir-Light", size: 14)
        nameLabel.sizeToFit()
        nameLabel.frame = CGRectMake(64, (48 - nameLabel.frame.size.height) / 2, nameLabel.frame.size.width, nameLabel.frame.size.height)
        
        var timeLabel = UILabel()
        timeLabel.text = indexPath.section == 0 ? "\(Int(topTracks[indexPath.row].duration))" : "\(albums[indexPath.row].firstTrackPage.items.count) Songs"
        timeLabel.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        timeLabel.font = UIFont(name: "Avenir-Light", size: 14)
        
        if indexPath.section == 0 {
            var mins = 0
            var secs = Int(topTracks[indexPath.row].duration)
            
            while secs >= 60 {
                secs -= 60
                mins += 1
            }
            
            let secstr = NSString(format: "%02d", secs)
            timeLabel.text = "\(mins):\(secstr)"
        }
        
        timeLabel.sizeToFit()
        timeLabel.frame = CGRectMake(tableView.bounds.size.width - timeLabel.frame.size.width - 38, (48 - timeLabel.frame.size.height) / 2, timeLabel.frame.size.width, timeLabel.frame.size.height)
        
        nameLabel.frame.size.width = timeLabel.frame.origin.x - nameLabel.frame.origin.x - 16
        
        cell.addSubview(numLabel)
        cell.addSubview(nameLabel)
        cell.addSubview(timeLabel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
