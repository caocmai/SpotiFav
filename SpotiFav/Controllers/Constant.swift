//
//  Constant.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/18/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct K {
    static let SPOTIFY_API_CLIENT_ID = "619a17870dfc41da9bd10736497f8bd2"
    static let SPOTIFY_API_SCRET_KEY = "dd5e252ed5754c4889f733a82f5135e2"
    static let REDIRECT_URI = "spotifav://callback"
    static let SCOPE = ["user-read-email", "user-top-read"]
    static let RESPONSE_TYPE = "code" // not using at the moment
}
