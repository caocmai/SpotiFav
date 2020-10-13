//
//  SpotifyType.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

enum SpotifyType: String {
    case album = "ablum"
    case artist = "artist"
    case playlist = "playlist"
    case track = "track"
    case show = "show"
    case episode = "episode"

//    func getSpotifyType() -> String {
//        switch self {
//        case .album:
//            return "album"
//        case .artist:
//            return "artist"
//        case .playlist:
//            return "playlist"
//        case .track:
//            return "track"
//        case .show:
//            return "show"
//        case .episode:
//            return "episode"
//        }
//    }
}

enum MyTopType: String {
    case tracks = "tracks"
    case artists = "artists"

//    func getType() -> String {
//        switch self {
//        case .tracks:
//            return "tracks"
//        case .artists:
//            return "artists"
//        }
//    }
}


enum Country: String {
    case US = "US"
    case UK = "UK"
}
