//
//  SearchViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/29/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var searchTerm: String!
    
    var searchResults = [SPTPartialArtist]()
    
    var uriToSend: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.height, 12))
        
        SPTRequest.performSearchWithQuery("A", queryType: .QueryTypeArtist, session: spotifySession) { (error, list) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                let listPage = list as SPTListPage
                let artists = listPage.items as [SPTPartialArtist]
                
                self.searchResults = artists
                
                self.tableView.reloadData()
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        SPTRequest.performSearchWithQuery(textField.text, queryType: .QueryTypeArtist, session: spotifySession) { (error, list) -> Void in
            if error != nil {
                println(error.localizedDescription)
            } else {
                let lp = list as SPTListPage
                
                if let artists = lp.items {
                    let arts = artists as [SPTPartialArtist]
                    self.searchResults = arts
                    self.tableView.reloadData()
                }
            }
        }
        
        return true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 48))
        header.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        var title = UILabel()
        title.text = "Spotify Results"
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
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "ArtistCell")
        
        cell.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        
        let backView = UIImageView(frame: cell.frame)
        backView.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        
        cell.selectedBackgroundView = backView
        
        let nameLabel = UILabel()
        nameLabel.text = searchResults[indexPath.row].name
        nameLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        nameLabel.font = UIFont(name: "Avenir-Light", size: 14)
        nameLabel.sizeToFit()
        nameLabel.frame = CGRectMake(38, (48 - nameLabel.frame.size.height) / 2, nameLabel.frame.size.width, nameLabel.frame.size.height)
        
        let typeLabel = UILabel()
        typeLabel.text = "Artist"
        typeLabel.textColor = UIColor(red: 0.36, green: 0.36, blue: 0.36, alpha: 1)
        typeLabel.font = UIFont(name: "Avenir-Light", size: 14)
        typeLabel.sizeToFit()
        typeLabel.frame = CGRectMake(tableView.frame.size.width - 38 - typeLabel.frame.size.width, (48 - typeLabel.frame.size.height) / 2, typeLabel.frame.size.width, typeLabel.frame.size.height)
        
        cell.addSubview(nameLabel)
        cell.addSubview(typeLabel)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        uriToSend = searchResults[indexPath.row].uri
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("artistSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let avc = segue.destinationViewController as ArtistViewController
        avc.artistURI = uriToSend
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
