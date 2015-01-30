//
//  HMRequest.swift
//  Harmonize
//
//  Created by Jack Cook on 1/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

class HMRequest: NSObject {
    
    class func requestFeaturedAlbums(block: [HMAlbum] -> Void) {
        var newAlbums = [HMAlbum]()
        
        /*if spotifyAuthenticated {
            let url = NSURL(string: "https://api.spotify.com/v1/browse/new-releases")!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            
            request.addValue("Bearer BQDYfE-Pwwnov8iE1kTqNLINJqzSQeUAXa514uvpq_IkP55qfXJpYpwpbxp9MotZkDxiSqVzi-2WGRrzeiwLbjdEDhLiIKI67Dob01Acp7MoGDZfFnEf4qVSZj9b35CM_HdUKeG0gpByJM5BuWs_EyK2HvajMcjSNdu1Xzs7YmVwzJ4F4e5FEA8hEBm45j5VUJcqJadsh--LqyPHG-DbVM5aE-btrl9_waASpAmZBIP5e_myMibdjaO7qTX1fMp4j4IdSEwsjrGTBeHVP8RxDYJtA51k7Mq3QRA", forHTTPHeaderField: "Authorization")
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                let json = JSON(data: data)
                if let albums = json["albums"]["items"].array {
                    var ids = ""
                    for album in albums {
                        if let id = album["id"].string {
                            ids += "," + id
                        }
                    }
                    
                    let url = NSURL(string: "https://api.spotify.com/v1/albums?ids=\(ids)")!
                    let request = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "GET"
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                        let json = JSON(data: data)
                        for (index: String, album: JSON) in json["albums"] {
                            println(album["name"])
                        }
                        
                        block(newAlbums)
                        
                        /if let albums = json["albums"].array {
                            
                            
                            for album in albums {
                                let newAlbum = HMAlbum()
                                if let name = album["name"] {
                                    newAlbum.name = name
                                }
                                newAlbum.name = album["name"].string!
                                newAlbum.imageURL = NSURL(string: album["images"].array![0]["url"].string!)
                                newAlbum.releaseYear = Int(album["release_date"].string!.componentsSeparatedByString("-")[2])
                            }
                        }*
                    })
                }
            })
        }*/
        
        var albums = [HMAlbum]()
        
        if spotifyAuthenticated {
            let locale = NSLocale.currentLocale()
            let countryCode = locale.objectForKey(NSLocaleCountryCode) as String
            
            SPTRequest.requestNewReleasesForCountry(countryCode, limit: 6, offset: 0, session: spotifySession, callback: { (error, listPage) -> Void in
                if error != nil {
                    println("\(error.localizedDescription)")
                }
                
                let lp = listPage as SPTListPage
                
                for partialAlbum in lp.items {
                    HMAlbum.fromSpotifyPartialAlbum(partialAlbum as SPTPartialAlbum) { (album) -> Void in
                        if error != nil {
                            println("\(error.localizedDescription)")
                        } else {
                            albums.append(album)
                            
                            if albums.count == listPage.count {
                                block(albums)
                            }
                        }
                    }
                }
            })
        }
    }
}
