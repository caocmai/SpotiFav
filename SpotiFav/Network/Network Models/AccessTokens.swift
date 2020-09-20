//
//  AccessTokens.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/18/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct AccessTokens: Decodable {
    let accessToken: String
    let tokenExpiration: Int
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenExpiration = "expires_in"
        case refreshToken = "refresh_token"
    }
}
