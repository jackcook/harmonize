//
//  HMArtist.swift
//  Harmonize
//
//  Created by Jack Cook on 1/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

class HMArtist: NSObject {
    
    var name: String!
    var genres = [String]()
    var imageURL: NSURL!
    var followerCount = 0
    
    var topTracks = [HMTrack]()
    var albums = [HMAlbum]()
    
    var source: HMSource!
    
    private var spotifyURI: NSURL!
    
    class func fromSpotifyArtist(spotifyArtist: SPTArtist, block: HMArtist -> Void) {
        let artist = HMArtist()
        artist.source = .Spotify
        
        artist.name = spotifyArtist.name
        artist.genres = spotifyArtist.genres as [String]
        artist.imageURL = spotifyArtist.largestImage.imageURL
        artist.followerCount = spotifyArtist.followerCount
        
        let locale = NSLocale.currentLocale()
        let countryCode = locale.objectForKey(NSLocaleCountryCode) as String
        
        var tracksDone = false
        var albumsDone = false
        
        spotifyArtist.requestTopTracksForTerritory(countryCode, withSession: spotifySession) { (error, tracks) -> Void in
            for track in tracks as [SPTTrack] {
                HMTrack.fromSpotifyTrack(track) { (newTrack) -> Void in
                    artist.topTracks.append(newTrack as HMTrack)
                    if artist.topTracks.count == tracks.count {
                        tracksDone = true
                        
                        if tracksDone && albumsDone {
                            block(artist)
                        }
                    }
                }
            }
        }
        
        spotifyArtist.requestAlbumsOfType(.Album, withSession: spotifySession, availableInTerritory: countryCode) { (error, listPage) -> Void in
            let lp = listPage as SPTListPage
            
            for album in lp.items as [SPTPartialAlbum] {
                HMAlbum.fromSpotifyPartialAlbum(album) { (newAlbum) -> Void in
                    artist.albums.append(newAlbum as HMAlbum)
                    if artist.albums.count == listPage.count {
                        albumsDone = true
                        
                        if tracksDone && albumsDone {
                            block(artist)
                        }
                    }
                }
            }
        }
    }
    
    class func fromSpotifyPartialArtist(spotifyArtist: SPTPartialArtist, block: HMArtist -> Void) {
        SPTRequest.requestItemFromPartialObject(spotifyArtist, withSession: spotifySession) { (error, artist) -> Void in
            HMArtist.fromSpotifyArtist(artist as SPTArtist) { (artist) -> Void in
                block(artist)
            }
        }
    }
    
    class func fromSpotifyURI(spotifyURI: String, block: HMArtist -> Void) {
        SPTArtist.artistWithURI(NSURL(string: spotifyURI), session: spotifySession) { (error, artist) -> Void in
            HMArtist.fromSpotifyArtist(artist as SPTArtist) { (artist) -> Void in
                block(artist)
            }
        }
    }
}
