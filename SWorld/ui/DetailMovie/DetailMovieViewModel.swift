//
//  DetailMovieViewModel.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 15/11/21.
//

import RxSwift
import RxCocoa

class DetailMovieViewModel {
    private let respositoryMovies: RepositoryMovies
    private let movieId: Int
    private let info = BehaviorRelay<String>(value: "")
    private let posterPath = BehaviorRelay<String>(value: "")
    private let image = BehaviorRelay<UIImage>(value: UIImage())
    private let detail = BehaviorRelay<DetailMovie>(value: DetailMovie())
    let productionCompanies = BehaviorRelay<[ProductionCompany]>(value: [])

    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "yyyy"
        return $0
    }(DateFormatter())
    
    public init(_ movieId: Int,repository: RepositoryMovies = RepositoryMovies.shared) {
        self.movieId = movieId
        self.respositoryMovies = repository
    }
    
    public var imagePath:  Driver<String> {
        return posterPath.asDriver()
    }
    
    public var movieInfo: Driver<String> {
        return info.asDriver()
    }
    
    public var imageInfo: Driver<UIImage> {
        return image.asDriver()
    }
    
    public var detailMovie: Driver<DetailMovie> {
        return detail.asDriver()
    }
    
    public func fetchMovieDetail() {
        respositoryMovies.seeMovie(for: self.movieId) {[weak self] result in
            switch result {
            case .success(let detail):
                self?.info.accept(self?.getResumeString(movieDetail: detail) ?? "")
                self?.posterPath.accept(detail.posterPath ?? "")
                self?.detail.accept(detail)
                self?.productionCompanies.accept(Array(detail.productionCompanies))
            case .failure(_):
                self?.info.accept("")
                self?.productionCompanies.accept([])
            }
        }
    }
    
    private func getResumeString(movieDetail: DetailMovie?) -> String {
        if let detail = movieDetail {
            var details = ""
            if let releaseDate = detail.releaseDate {
                details += DetailMovieViewModel.dateFormatter.string(from: releaseDate)
            }
            if let runtime = detail.runtime {
                details += (details.isEmpty ? "" : " • ") + "\(runtime) min"
            }
            details += (details.isEmpty ? "" : " • ") + "\(detail.voteAverage ?? 0.0)/10 ★"
            return details
        }
        return ""
    }
}
