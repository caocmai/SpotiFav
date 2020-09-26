
//
//  TopTracks.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/17/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct UserTopArtists: Model {
    let items: [ArtistItem]
}

struct ArtistItem: Model {
    let id: String
    let name: String
    let images: [ArtistImage]
}

struct ArtistImage: Model {
    let height: Int
    let url: URL
}

// not using
struct Artists: Model {
    let artists: [Artist]
}
