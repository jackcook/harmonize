//
//  HMAlbum.swift
//  Harmonize
//
//  Created by Jack Cook on 1/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

class HMAlbum: NSObject {
    
    var name: String!
    var artists = [HMArtist]()
    var tracks = [HMTrack]()
    var releaseYear = 0
    var genres = [String]()
    var imageURL: NSURL!
    var type: HMAlbumType!
    
    var source: HMSource!
    
    class func fromSpotifyAlbum(spotifyAlbum: SPTAlbum, block: HMAlbum -> Void) {
        let album = HMAlbum()
        album.source = .Spotify
        
        album.name = spotifyAlbum.name
        
        for artist in spotifyAlbum.artists as [SPTArtist] {
            HMArtist.fromSpotifyArtist(artist) { (newArtist) -> Void in
                album.artists.append(newArtist)
            }
        }
        
        for track in spotifyAlbum.firstTrackPage.items as [SPTPartialTrack] {
            HMTrack.fromSpotifyPartialTrack(track) { (newTrack) -> Void in
                album.tracks.append(newTrack)
            }
        }
        
        album.releaseYear = spotifyAlbum.releaseYear
        album.genres = spotifyAlbum.genres as [String]
        album.imageURL = spotifyAlbum.largestCover.imageURL
        album.type = HMAlbumType.fromSpotifyAlbumType(spotifyAlbum.type)
    }
    
    class func fromSpotifyPartialAlbum(spotifyAlbum: SPTPartialAlbum, block: HMAlbum -> Void) {
        SPTRequest.requestItemFromPartialObject(spotifyAlbum, withSession: spotifySession) { (error, album) -> Void in
            HMAlbum.fromSpotifyAlbum(album as SPTAlbum) { (album) -> Void in
                block(album)
            }
        }
    }
    
    class func fromSpotifyURI(spotifyURI: String, block: HMAlbum -> Void) {
        SPTAlbum.albumWithURI(NSURL(string: spotifyURI), session: spotifySession) { (error, album) -> Void in
            HMAlbum.fromSpotifyAlbum(album as SPTAlbum) { (album) -> Void in
                block(album)
            }
        }
    }
}
