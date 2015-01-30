//
//  SearchViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/29/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var searchTerm: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.height, 12))
        
        SPTRequest.performSearchWithQuery(searchTerm, queryType: .QueryTypeArtist, session: spotifySession) { (error, artists) -> Void in
            let a = artists as [SPTArtist]
        }
    }
}
