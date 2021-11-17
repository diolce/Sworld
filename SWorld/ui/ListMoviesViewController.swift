//
//  ListMoviesViewController.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class ListMoviesViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ListMoviesViewModel()
    weak var coordinator: MainCoordinator?
    let disposeBag = DisposeBag()
    
    private lazy var viewSpinner: UIView = {
            let view = UIView(frame: CGRect(
                                x: 0,
                                y: 0,
                                width: self.view.frame.size.width,
                                height: 100)
            )
            let spinner = UIActivityIndicatorView()
            spinner.center = view.center
            view.addSubview(spinner)
            spinner.startAnimating()
            return view
        }()
    
    private lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            return refreshControl
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)

        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func bind() {
        self.tableViewBind()
        
        self.viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
            }
        }.disposed(by: disposeBag)

        self.viewModel.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }.disposed(by: disposeBag)
        
        self.searchBarBind()
    }

    
    private func tableViewBind() {
        self.tableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        self.viewModel.movies.bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) { row, model, cell in
            cell.movie = model
        }.disposed(by: disposeBag)
       
        self.tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }.disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(Movie.self)
            .map{ $0.id }
            .subscribe(onNext: { [weak self] movieId in
                self!.coordinator?.seeMovie(id: movieId)
        }).disposed(by: disposeBag)
        
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func searchBarBind() {
        searchBar.rx.text.orEmpty.subscribe(onNext: { [weak self] (queryString) in
            if !queryString.isEmpty {
                self?.viewModel.fetchMovies(searchText: queryString)
            } else {
                self?.viewModel.cancelSearch()
                self?.searchBar?.resignFirstResponder()
                self?.viewModel.movies.accept([])
                self?.viewModel.fetchMoreDatas.onNext(())
            }
        }).disposed(by: disposeBag)
        
        self.searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                self.viewModel.cancelSearch()
                searchBar!.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        self.searchBar.rx
           .cancelButtonClicked
           .asDriver(onErrorJustReturn: ())
           .drive(onNext: { [weak searchBar] in
              searchBar?.resignFirstResponder()
              searchBar?.showsCancelButton = false
           })
           .disposed(by: disposeBag)
    }
    
    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
    }
}

extension ListMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 171
    }
}
