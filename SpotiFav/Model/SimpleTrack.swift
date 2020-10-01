//
//  SimpleTrack.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/30/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct SimpleTrack {
    let id: String
    let title: String
    let previewUrl: URL?
    let images: [ArtistImage]
    
    init(id: String, title: String, previewURL: URL?, images: [ArtistImage]) {
        self.id = id
        self.title = title
        self.previewUrl = previewURL
        self.images = images
    }
}
