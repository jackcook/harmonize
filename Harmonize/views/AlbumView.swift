//
//  AlbumView.swift
//  Harmonize
//
//  Created by Jack Cook on 1/22/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    init(album: SPTAlbum, frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1)
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, frame.size.width, frame.size.width))
        Mozart().load(album.largestCover.imageURL.absoluteString!).into(imageView)
        
        let albumTitle = UILabel(frame: CGRectMake(4, imageView.frame.size.height + 14, frame.size.width - 8, 12))
        albumTitle.text = album.name
        albumTitle.textAlignment = .Center
        albumTitle.textColor = UIColor(red: 0.83, green: 0.83, blue: 0.83, alpha: 1)
        albumTitle.font = UIFont(name: "Avenir-Light", size: 12)
        
        let genreImage = UIImageView(frame: CGRectMake(11, self.frame.size.height - 11 - 14, 14, 14))
        Mozart().load("http://puu.sh/f9vlF/ab22dbe3f5.png").into(genreImage)
        
        let albumYear = UILabel(frame: CGRectMake(genreImage.frame.origin.x + genreImage.frame.size.width + 10, self.frame.size.height - 11 - 8, self.frame.size.width - genreImage.frame.origin.x - genreImage.frame.size.width - 10 - 11, 8))
        albumYear.text = "\(album.releaseYear)"
        albumYear.textAlignment = .Right
        albumYear.textColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        albumYear.font = UIFont(name: "Avenir-Light", size: 8)
        
        let artistName = UILabel(frame: CGRectMake(genreImage.frame.origin.x + genreImage.frame.size.width + 10, albumYear.frame.origin.y - 8 - 7, self.frame.size.width - genreImage.frame.origin.x - genreImage.frame.size.width - 10 - 11, 10))
        artistName.text = album.artists[0].name
        artistName.textAlignment = .Right
        artistName.textColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
        artistName.font = UIFont(name: "Avenir-Light", size: 9)
        
        self.addSubview(imageView)
        self.addSubview(albumTitle)
        self.addSubview(genreImage)
        self.addSubview(artistName)
        self.addSubview(albumYear)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
