//
//  RepositoryData.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 16/11/21.
//

import RealmSwift

class RepositoryMovies {
    var repositoryMovies:RealmService
    var apiRepository: MoviesService
    
    private init(repository:RealmService = RealmService.shared,
                 service: MoviesService = MoviesService.shared) {
        self.repositoryMovies = repository
        self.apiRepository = service

    }
    
    static let shared = RepositoryMovies()
    
    func getMoviesLocal(query:String?) -> [Movie] {
        let results = self.repositoryMovies.realm.objects(Movie.self)
        if let query = query {
            return Array(results.filter("title CONTAINS %@",query))
        } else {
            return Array(results)
        }
    }
    
    func getMovies(query:String?,page: Int,maxPage:Int, completion: @escaping (Result<DatasResponse,ErrorModel>)-> Void) {
        apiRepository.fetchListMovies(query:query,page: page, maxPage: maxPage) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let datasResponse):
                    completion(.success(datasResponse))
                    if let movies = datasResponse.results {self.saveMovies(movies: movies)}
                case .failure(let errorModel):
                    completion(.failure(errorModel))
                }
            }
        }
    }
    
    func seeMovie(for id:Int,completion: @escaping (Result<DetailMovie,ErrorModel>)-> Void) {
        let results = Array(self.repositoryMovies.realm.objects(DetailMovie.self).filter({ $0.id == id }))
        if results.count == 1 {
            completion(.success(results[0]))
        }
        self.apiRepository.seeMovie(for: id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detailMovie):
                    if results.count == 0 {completion(.success(detailMovie))}
                    //Añado al repositorio
                    self.repositoryMovies.createOrUpdate(detailMovie)
                case .failure(let errorModel):
                    completion(.failure(errorModel))
                }
            }
        }
    }
    
    func saveMovies(movies:[Movie]) {
        for i in movies {
            repositoryMovies.createOrUpdate(i)
        }
    }
}
