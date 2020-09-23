//
//  Parameters.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/22/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

enum PostParameters {
    case codeForToken(accessCode: String)
    case refreshTokenForAccessCode(refreshToken: String)

    func getCodeForToken() -> [String:Any] {
        switch self {
        case .codeForToken(let code):
            return ["grant_type": "authorization_code",
                    "code": "\(code)",
                    "redirect_uri": K.REDIRECT_URI]
        case .refreshTokenForAccessCode(let refreshToken):
            return ["grant_type": "refresh_token",
                    "refresh_token": refreshToken
            ]
        }
    }
}
