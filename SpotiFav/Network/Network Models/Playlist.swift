//
//  Playlists.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct Playlist: Model {
    let name: String
    let images: [PlaylistImage]
    let tracks: Track
}

struct PlaylistImage: Model {
    let url: URL
}

struct Track: Model {
    let items: [Item]
}

struct Item: Model {
    let track: Alumn
}

struct Alumn: Model {
    let album: AlumnDetail?
    let artists: [Artist]
//    let popularity: Int
    let name: String
    let durationMs: Int?
    let previewUrl: URL?
    let images: [ArtistImage]?
    
//    enum CodingKeys: String, CodingKey {
//        case artists
////        case popularity
//        case durationMS = "duration_ms"
//        case previewURL = "preview_url"
//    }
    
}

struct AlumnDetail: Model {
    let name: String
    let images: [ArtistImage]
}

struct Artist: Model {
    let name: String
    let type: String
//    let images: [ArtistImage]?
}

