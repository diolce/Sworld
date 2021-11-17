//
//  ListMoviesRequest.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import Foundation

class ListMoviesRequest: APIRequest {
    var apiKey: String? = apiKeyTheMovieDB

    var parameters: [String : Any]?
    var baseURLString: String

    var relativePath: String = "/3/movie/popular"
    var method: HTTPMethod = .get

    var queryItem: [URLQueryItem]? = []

    init(baseUrl: String, page: Int?, query:String?) {
        
        self.baseURLString = baseUrl
        
        //Add apiKey
        let queryItem = URLQueryItem(name: "api_key", value: apiKey!)
        self.queryItem?.append(queryItem)
        
        
        if let page = page {
            let queryItem = URLQueryItem(name: "page", value: String(page))
            self.queryItem?.append(queryItem)
        }
        
        if let query = query {
            self.relativePath = "/3/search/movie"
            let queryItem = URLQueryItem(name: "query", value: String(query))
            self.queryItem?.append(queryItem)
        }
    }
}
