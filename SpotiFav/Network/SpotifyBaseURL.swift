//
//  SpotifyBaseURL.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

enum SpotifyBaseURL {
    
    case authBaseURL
    case APICallBase
}

extension SpotifyBaseURL {
    var url: URL {
        get {
            switch self {
            case .authBaseURL:
                return URL(string: "https://accounts.spotify.com/api/")!
            case .APICallBase:
                return URL(string: "https://api.spotify.com/v1/")!
            }
        }
    }
}
