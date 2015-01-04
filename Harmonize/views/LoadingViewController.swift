//
//  LoadingViewController.swift
//  Harmonize
//
//  Created by Jack Cook on 1/3/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

class LoadingViewController: UIViewController {
    
    var gifView: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            if SSKeychain.passwordForService("harmonize", account: "spotify") != nil {
                authenticateSpotify()
            } else {
                let spotifyAuth = SPTAuth.defaultInstance()
                let spotifyLoginURL = spotifyAuth.loginURLForClientId(spotifyClientID, declaredRedirectURL: NSURL(string: spotifyCallbackURL), scopes: [SPTAuthStreamingScope])
                UIApplication.sharedApplication().openURL(spotifyLoginURL)
            }
            
            if SSKeychain.passwordForService("harmonize", account: "soundcloud") != nil {
                authenticateSoundCloud()
            } else {
                let soundCloudLoginURL = NSURL(string: "https://soundcloud.com/connect?client_id=\(soundCloudClientID)&response_type=code&redirect_uri=\(soundCloudCallbackURL)")!
                UIApplication.sharedApplication().openURL(soundCloudLoginURL)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let imagePath = NSBundle.mainBundle().URLForResource("loading", withExtension: "gif")
        let stringPath = imagePath?.absoluteString
        let data = NSData(contentsOfURL: NSURL(string: stringPath!)!)
        
        let gif = FLAnimatedImage(animatedGIFData: data)
        
        gifView = FLAnimatedImageView()
        gifView.animatedImage = gif
        
        var width = deviceSize.width - 190
        var height = width / (636 / 572)
        
        gifView.frame = CGRectMake(95, (deviceSize.height - height) / 2.5, width, height)
        
        self.view.addSubview(gifView)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(4.5, target: self, selector: "finished", userInfo: nil, repeats: false)
    }
    
    func finished() {
        gifView.image = UIImage(named: "loading.gif")
        self.performSegueWithIdentifier("browseSegue", sender: self)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
