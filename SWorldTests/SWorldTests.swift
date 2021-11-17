//
//  SWorldTests.swift
//  SWorldTests
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import XCTest
@testable import SWorld

class SWorldTests: XCTestCase {
    let movieId = 635302
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUrl_ListMoviesRequest_ALL() {
        let listMoviesRequest = ListMoviesRequest(baseUrl: "api.themoviedb.org", page: 1, query: nil)
        let expectedResult = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=9025c934e8169ca0cc30b48df2817863&page=1")!)
        XCTAssertEqual(expectedResult,listMoviesRequest.urlRequest)
    }

    func testUrl_ListMoviesRequest_Search() {
        let listMoviesRequest = ListMoviesRequest(baseUrl: "api.themoviedb.org", page: 1, query: "Gladiator")
        let expectedResult = URLRequest(url: URL(string: "https://api.themoviedb.org/3/search/movie?api_key=9025c934e8169ca0cc30b48df2817863&page=1&query=Gladiator")!)
        XCTAssertEqual(expectedResult,listMoviesRequest.urlRequest)
    }
    
    func testUrl_DetailMovieRequest() {
        
        let detailMovieRequest = DetailMovieRequest(baseUrl: "api.themoviedb.org", movieId: movieId)
        let expectedResult = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=9025c934e8169ca0cc30b48df2817863")!)
        XCTAssertEqual(expectedResult,detailMovieRequest.urlRequest)
    }
    
    func testApiAll() {
        ApiManager.shared.listMovies(query: nil, page: 1) {result in
            switch result {
            case .success(let dataResponse):
                if let result = dataResponse.results {
                    XCTAssertNotEqual(result.count, 0)
                }
            case .failure(let errorModel):break
            }
        }
    }
    
    func testSearchApi() {
        ApiManager.shared.listMovies(query: "Gladiator", page: 1) {result in
            switch result {
            case .success(let dataResponse):
                if let result = dataResponse.results {
                    XCTAssertNotEqual(result.count, 0)
                }
            case .failure(let errorModel):break
            }
        }
    }
    
    func testDetailApi() {
        ApiManager.shared.seeMovie(id: movieId) {result in
            switch result {
            case .success(let detailMovie):
                XCTAssertEqual(detailMovie.id, self.movieId)
            case .failure(let errorModel):break
            }
        }
    }
}
