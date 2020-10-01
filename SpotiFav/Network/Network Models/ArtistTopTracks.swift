//
//  ArtistTopTracks.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/24/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct ArtistTopTracks: Model {
    let tracks: [ArtistTrack]
}

struct ArtistTrack: Model {
    let id: String
    let name: String
    let previewUrl: URL?
    let album: Alumn
}
