//
//  LoadingView.swift
//  Harmonize
//
//  Created by Jack Cook on 1/2/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class LoadingView: UIView {
    
    var background: UIImageView!
    var gifView: FLAnimatedImageView!
    
    var viewController: HarmonizeViewController!
    
    override init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.backgroundColor = UIColor(red: (37 / 255), green: (37 / 255), blue: (37 / 255), alpha: 1)
        
        background = UIImageView(frame: self.bounds)
        background.image = UIImage(named: "background01.png")
        
        let imagePath = NSBundle.mainBundle().URLForResource("loading", withExtension: "gif")
        let stringPath = imagePath?.absoluteString
        let data = NSData(contentsOfURL: NSURL(string: stringPath!)!)
        
        let gif = FLAnimatedImage(animatedGIFData: data)
        
        gifView = FLAnimatedImageView()
        gifView.animatedImage = gif
        
        var width = deviceSize.width - 190
        var height = width / (636 / 572)
        
        gifView.frame = CGRectMake(95, (deviceSize.height - height) / 2.5, width, height)
        
        self.addSubview(background)
        self.addSubview(gifView)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(4.5, target: self, selector: "finished", userInfo: nil, repeats: false)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func finished() {
        gifView.image = UIImage(named: "loading.gif")
        viewController.loadingDone()
    }
}