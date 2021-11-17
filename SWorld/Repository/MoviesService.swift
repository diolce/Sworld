//
//  Dummy.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 13/11/21.
//

import Foundation

class MoviesService {
    private init() {}
    static let shared = MoviesService()

    func fetchListMovies(query: String? = nil,page: Int,maxPage:Int, completion: @escaping (Result<DatasResponse,ErrorModel>)-> Void) {
        if page <= maxPage {
            ApiManager.shared.listMovies(query:query,page: page, completion: completion)
        } else {
            completion(.failure(ErrorModel(status: "", timeStamp: "", code: 500, message: "No data")))
        }
    }
    
    func seeMovie(for id: Int,completion: @escaping (Result<DetailMovie,ErrorModel>) -> Void) {
        ApiManager.shared.seeMovie(id: id,completion: completion)
    }
}
