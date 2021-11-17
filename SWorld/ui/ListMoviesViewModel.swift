//
//  ListMoviesViewModel.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 13/11/21.
//

import RxCocoa
import RxSwift

class ListMoviesViewModel {
    private let disposeBag = DisposeBag()
    private let respositoryMovies: RepositoryMovies
    var query:String? = nil
    let movies = BehaviorRelay<[Movie]>(value: [])
    let fetchMoreDatas = PublishSubject<Void>()
    let refreshControlAction = PublishSubject<Void>()
    let refreshControlCompelted = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    public var isFetching = false
    private var pageCounter = 1
    private var totalPages = 1
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    
    init(repository: RepositoryMovies = RepositoryMovies.shared) {
        self.respositoryMovies = repository
        self.bind()
    }

    private func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchMovies(page: self.pageCounter,isRefreshControl: false)
        }.disposed(by: disposeBag)

        self.refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }.disposed(by: disposeBag)
    }
    
    private func fetchMovies(page: Int, isRefreshControl: Bool) {
        self.movies.accept([])
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        if pageCounter > totalPages  {
            isPaginationRequestStillResume = false
            return
        }
       
        self.isPaginationRequestStillResume = true
        self.isLoadingSpinnerAvaliable.onNext(true)
        
        if self.pageCounter == 1  || isRefreshControl {
            self.isLoadingSpinnerAvaliable.onNext(false)
        }
    
        let resultSearch = self.respositoryMovies.getMoviesLocal(query: self.query)
        self.movies.accept(resultSearch)
        
        self.respositoryMovies.getMovies(query:self.query,page: page, maxPage: totalPages) {[weak self] result in
            self?.handleData(gotResult: !(resultSearch.count == 0),result: result)
        }
    }

    private func paginationControl(data: DatasResponse?) {
        if let data = data,let totalPages = data.total_pages {
            self.totalPages = totalPages
            self.pageCounter += 1
        }
    }
    
    private func refreshControlTriggered() {
        self.isPaginationRequestStillResume = false
        self.pageCounter = 1
        self.movies.accept([])
        self.fetchMovies(page: self.pageCounter,isRefreshControl: true)
    }
    
    func cancelSearch() {
        self.query = nil
        self.pageCounter = 1
        self.isFetching = false
    }
    
    func getSearch(query:String) {
        self.query = query
        self.pageCounter = 1
        self.isFetching = true
    }
    
    func fetchMovies(searchText: String) {
        self.movies.accept([])
        self.getSearch(query:searchText)
        let resultSearch = self.respositoryMovies.getMoviesLocal(query: searchText)
        self.movies.accept(resultSearch)
        self.respositoryMovies.getMovies(query: searchText, page: self.pageCounter, maxPage: self.totalPages) {[weak self] result in
            self?.handleData(gotResult: !(resultSearch.count == 0),result: result)
        }
    }
    
    private func handleData(gotResult:Bool,result:Result<DatasResponse,ErrorModel>) {
        switch result {
        case .success(let datasResponse):
            if !gotResult {
                self.movies.accept(datasResponse.results ?? [])
            }
            self.paginationControl(data: datasResponse)
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            self.isRefreshRequstStillResume = false
            self.refreshControlCompelted.onNext(())
        case .failure(_): break
        }
    }
}
