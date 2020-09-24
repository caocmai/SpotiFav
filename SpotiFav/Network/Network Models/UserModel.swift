//
//  UserModel.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct UserModel: Model {
    let displayName: String
    let email: String
}

//extension UserModel {
//     private enum UserCodingKeys: String, CodingKey {
//        case displayName = "display_name"
//        case email
//    }
//
//    init(from decoder: Decoder) throws {
//        let movieContainer = try decoder.container(keyedBy: UserCodingKeys.self)
//        displayName = try movieContainer.decode(String.self, forKey: .displayName)
//        email = try movieContainer.decode(String.self, forKey: .email)
//
//    }
//
//}
