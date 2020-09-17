//
//  File.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct ExpireToken: Decodable {
    let error: Error
   
}

struct Error: Decodable {
    let status: Int?
    let message: String?
}
