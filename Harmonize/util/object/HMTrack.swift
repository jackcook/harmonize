//
//  HMTrack.swift
//  Harmonize
//
//  Created by Jack Cook on 1/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

class HMTrack: NSObject {
    
    var name: String!
    var album: HMAlbum!
    
    var source: HMSource!
    
    class func fromSpotifyTrack(spotifyTrack: SPTTrack, block: HMTrack -> Void) {
        let track = HMTrack()
        track.source = .Spotify
        
        track.name = spotifyTrack.name
        
        HMAlbum.fromSpotifyPartialAlbum(spotifyTrack.album) { (album) -> Void in
            track.album = album
            block(track)
        }
    }
    
    class func fromSpotifyPartialTrack(spotifyTrack: SPTPartialTrack, block: HMTrack -> Void) {
        SPTRequest.requestItemFromPartialObject(spotifyTrack, withSession: spotifySession) { (error, track) -> Void in
            HMTrack.fromSpotifyTrack(track as SPTTrack) { (track) -> Void in
                block(track)
            }
        }
    }
    
    class func fromSpotifyURI(spotifyURI: String, block: HMTrack -> Void) {
        SPTTrack.trackWithURI(NSURL(string: spotifyURI), session: spotifySession) { (error, track) -> Void in
            HMTrack.fromSpotifyTrack(track as SPTTrack) { (track) -> Void in
                block(track)
            }
        }
    }
}
