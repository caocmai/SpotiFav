
//
//  TopTracks.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/17/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct MyTopArtists: Decodable {
    let items: [ArtistItem]
}

struct ArtistItem: Decodable {
    let id: String
    let name: String
}
