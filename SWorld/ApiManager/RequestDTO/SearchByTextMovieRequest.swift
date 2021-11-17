//
//  SearchByTextMovieRequest.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 15/11/21.
//

import Foundation

class SearchByTextMovieRequest: APIRequest {
    var apiKey: String? = apiKeyTheMovieDB

    var parameters: [String : Any]?
    var baseURLString: String

    var relativePath: String = "/3/search/movie"
    var method: HTTPMethod = .get

    var queryItem: [URLQueryItem]? = []

    init(baseUrl: String, searchText: String?) {
        self.baseURLString = baseUrl
        
        //Add apiKey
        let queryItem = URLQueryItem(name: "api_key", value: apiKey!)
        self.queryItem?.append(queryItem)
        
        if let searchText = searchText {
            let queryItem = URLQueryItem(name: "query", value: searchText)
            self.queryItem?.append(queryItem)
        }
    }
}
