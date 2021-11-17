//
//  DetailMovieRequest.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 14/11/21.
//

import Foundation

class DetailMovieRequest: APIRequest {
    var apiKey: String? = apiKeyTheMovieDB

    var parameters: [String : Any]?
    var baseURLString: String

    var relativePath: String = "/3/movie/"
    var method: HTTPMethod = .get

    var queryItem: [URLQueryItem]? = []

    init(baseUrl: String, movieId: Int) {
        self.baseURLString = baseUrl
        self.relativePath = self.relativePath + String(movieId)
        
        //Add apiKey
        let queryItem = URLQueryItem(name: "api_key", value: apiKey!)
        self.queryItem?.append(queryItem)
    }
}
