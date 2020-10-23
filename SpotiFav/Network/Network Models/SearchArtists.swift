//
//  SearchArtists.swift
//  SpotiFav
//
//  Created by Cao Mai on 10/23/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct SearchArtists: Model {
    let artists: Artists
}

struct Artists: Model {
    let items: [ArtistItem]
}
