//
//  SpotifyType.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

enum SpotifyType {
    case album
    case artist
    case playlist
    case track
    case show
    case episode

    func getSpotifyType() -> String {
        switch self {
        case .album:
            return "album"
        case .artist:
            return "artist"
        case .playlist:
            return "playlist"
        case .track:
            return "track"
        case .show:
            return "show"
        case .episode:
            return "episode"
        }
    }
}

enum MyTopTypes {
    case tracks
    case artists

    func getType() -> String {
        switch self {
        case .tracks:
            return "tracks"
        case .artists:
            return "artists"
        }
    }
}


enum Country: String {
    case US = "US"
}
