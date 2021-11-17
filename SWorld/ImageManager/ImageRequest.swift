//
//  ImageRequest.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 17/11/21.
//

import UIKit

class ImageRequest: APIRequest {
    var apiKey: String?
    var parameters: [String : Any]?
    var baseURLString: String

    var relativePath: String = "/t/p/original/"
    var method: HTTPMethod = .get

    var queryItem: [URLQueryItem]? = []

    init(baseUrl: String, path: String) {
        self.baseURLString = baseUrl
        self.relativePath = relativePath + path
    }
}
