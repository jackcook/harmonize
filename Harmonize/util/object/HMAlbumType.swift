//
//  HMAlbumType.swift
//  Harmonize
//
//  Created by Jack Cook on 1/28/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import Foundation

enum HMAlbumType {
    case Album, Single, Compilation, AppearsOn
    
    static func fromSpotifyAlbumType(spotifyAlbumType: SPTAlbumType) -> HMAlbumType {
        switch spotifyAlbumType {
        case .Album:
            return .Album
        case .Single:
            return .Single
        case .Compilation:
            return .Compilation
        case .AppearsOn:
            return .AppearsOn
        }
    }
}
