//
//  Header.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

enum Header {
    case GETHeader(accessTokeny: String)
    case POSTHeader

    func buildHeader() -> [String:String] {
        switch self {
        case .GETHeader (let accessToken):
            return ["Accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(accessToken)"
            ]
        case .POSTHeader:
            // Spotify's required format for authorization
            let SPOTIFY_API_AUTH_KEY = "Basic \((K.SPOTIFY_API_CLIENT_ID + ":" + K.SPOTIFY_API_SCRET_KEY).data(using: .utf8)!.base64EncodedString())"
            return ["Authorization": SPOTIFY_API_AUTH_KEY,
                    "Content-Type": "application/x-www-form-urlencoded"]
        }
    }
}
