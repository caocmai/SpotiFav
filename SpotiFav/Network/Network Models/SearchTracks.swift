//
//  SearchTracks.swift
//  SpotiFav
//
//  Created by Cao Mai on 10/23/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct SearchTracks: Model {
    let tracks: Tracks
}

struct Tracks: Model {
    let items: [ArtistTrack]
}
