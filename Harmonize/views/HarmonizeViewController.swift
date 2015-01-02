//
//  HarmonizeViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class HarmonizeViewController: UIViewController {
    
    var nowPlayingView: NowPlayingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowPlayingView = NowPlayingView()
        self.view.addSubview(nowPlayingView)
    }
}
