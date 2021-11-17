//
//  ApiManager.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import UIKit

class ApiManager {
    private let baseURL:String
    private let session:URLSession
    
    private init(session:URLSession = URLSession(configuration: .default), bUrl:String = "api.themoviedb.org") {
        self.baseURL = bUrl
        self.session = session
    }
    static let shared = ApiManager()
    
    func listMovies(query:String?,page:Int?,completion: @escaping (Result<DatasResponse,ErrorModel>)-> Void) {
        let listCitiesRequest = ListMoviesRequest(baseUrl: self.baseURL, page: page, query: query)
        self.apiRequest(request: listCitiesRequest,completion: completion)
    }
    
    func seeMovie(id:Int,completion: @escaping (Result<DetailMovie,ErrorModel>)-> Void) {
        let detailMovieRequest = DetailMovieRequest(baseUrl: self.baseURL, movieId: id)
        self.apiRequest(request: detailMovieRequest, completion: completion)
    }
    
    private func apiRequest<T: Decodable, I: APIRequest>(request: I, completion: @escaping (Result<T, ErrorModel>)-> Void){
        let task = session.dataTask(with: request.urlRequest!) { data, response, error in
            if let error = error {
                let errorModel = ErrorModel(status: "", timeStamp: "", code: 0, message: error.localizedDescription)
                completion(.failure(errorModel))
                
            }else if let data = data {
                do {
                    let code = (response as! HTTPURLResponse).statusCode
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    if(code == 200) {
                        let decodeResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodeResponse))
                    }else{
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                            let decodeResponse = try decoder.decode(ErrorModel.self, from: data)
                            
                            completion(.failure(decodeResponse))
                        } catch let e{
                            let error = ErrorModel(status: "", timeStamp: "", code: 0, message: e.localizedDescription)
                            completion(.failure(error))
                        }
                    }
                } catch let e {
                    do {
                        let decodeResponse = try JSONDecoder().decode(ErrorModel.self, from: e as! Data)
                        completion(.failure(decodeResponse))
                    } catch {
                        let error = ErrorModel(status: "", timeStamp: "", code: 0, message: e.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
        }
        task.resume()
    }
}
    
