//
//  Playlists.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct Playlist: Decodable {
    let name: String
    let images: [PlaylistImage]
    let tracks: Track
}

struct PlaylistImage: Decodable {
    let url: URL
}

struct Track: Decodable {
    let items: [Item]
    
}

struct Item: Decodable {
    let track: Album
}

struct Album: Decodable {

    let artists: [Artist]
//    let popularity: Int
    let durationMS: Int
    let previewURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case artists
//        case popularity
        case durationMS = "duration_ms"
        case previewURL = "preview_url"
    }
    
}

struct Artist: Decodable {
    let name: String
    let type: String
}
