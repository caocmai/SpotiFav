//
//  EndingPath.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

enum EndingPath {

    case token
    case userInfo
    case artists(ids: [String])
    case artistTopTracks(artistId: String, country: Country)
    case search(q: String, type: SpotifyType)
    case playlists(id: String)
    case myTop(type: MyTopTypes)

    func getPath() -> String {
        switch self {
        case .token:
            return "token"
        case .userInfo:
            return "me"
        case .artists (let ids):
            return "artists&ids=\(ids.joined(separator: ","))"
        case .search(let q, let type):
            let convertSpacesToProperURL = q.replacingOccurrences(of: " ", with: "%20")
            return "search&q=\(convertSpacesToProperURL)&type\(type)"
        case .artistTopTracks(let id, let country):
            return "artists/\(id)/top-tracks&country\(country)"
        case .playlists (let id):
            return "playlists/\(id)"
        case .myTop(let type):
            return "me/top/\(type)"
        }
    }


}
