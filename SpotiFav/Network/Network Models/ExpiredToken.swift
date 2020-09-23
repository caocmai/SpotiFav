//
//  File.swift
//  SpotiFav
//
//  Created by Cao Mai on 9/16/20.
//  Copyright © 2020 Cao. All rights reserved.
//

import Foundation

struct ExpireToken: Model {
    let error: ErrorMessage
   
}

struct ErrorMessage: Model {
    let status: Int?
    let message: String?
}
