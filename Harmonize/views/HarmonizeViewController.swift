//
//  HarmonizeViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class HarmonizeViewController: UIViewController {
    
    var loadingView: LoadingView!
    var nowPlayingView: NowPlayingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView = LoadingView()
        loadingView.viewController = self
        //self.view.addSubview(loadingView)
        
        nowPlayingView = NowPlayingView()
        //nowPlayingView.alpha = 0
        //self.view.insertSubview(nowPlayingView, belowSubview: loadingView)
        self.view.addSubview(nowPlayingView)
    }
    
    func loadingDone() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.loadingView.alpha = 0
            self.nowPlayingView.alpha = 1
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
