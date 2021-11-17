//
//  ErrorModel.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 13/11/21.
//

import Foundation

struct ErrorModel: Codable, Error {
    var status: String
    var timeStamp: String
    var code: Int
    var message: String
}
