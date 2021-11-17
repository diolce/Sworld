//
//  DetailMovieViewController.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 14/11/21.
//

import RxSwift
import RxCocoa

class DetailMovieViewController: UIViewController {
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var title_movie: UILabel!
    @IBOutlet weak var detail_movie: UILabel!
    @IBOutlet weak var overview_movie: UILabel!
    @IBOutlet weak var credits: UIView!
    @IBOutlet weak var companies: UIView!
    @IBOutlet weak var labelCompanies: UILabel!
    @IBOutlet weak var collectionCompanies: UICollectionView!
    @IBOutlet weak var companiesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var crew: UIView!
    @IBOutlet weak var labelCrew: UILabel!
    @IBOutlet weak var collectionCrew: UICollectionView!
    
    weak var coordinator: MainCoordinator?
    var movieId:Int?
    let disposeBag = DisposeBag()
    private var detailMovieModelView: DetailMovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailMovieModelView = DetailMovieViewModel(self.movieId!)
        self.bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func bind() {
        self.collectionCompanies.register(ProductionCompaniesCollectionViewCell.nib, forCellWithReuseIdentifier: ProductionCompaniesCollectionViewCell.identifier)
        
        self.detailMovieModelView?.fetchMovieDetail()
        
        self.detailMovieModelView?
            .detailMovie
            .drive(onNext: { [weak self] (detail) in
                self!.imageMovie.image = ImageManager.shared.image(path: detail.posterPath ?? "")
                self!.title_movie.text = detail.title
                self!.overview_movie.text = detail.overview
                
            }).disposed(by: disposeBag)
        
        self.detailMovieModelView?
            .movieInfo
            .drive(onNext: { [weak self] (txt) in
                self?.detail_movie.text = txt
            }).disposed(by: disposeBag)
        
        self.detailMovieModelView?
            .imagePath
            .drive(onNext: { [weak self] (path) in
                self!.imageMovie.image = ImageManager.shared.image(path: path)
            }).disposed(by: disposeBag)
        
        self.detailMovieModelView.productionCompanies.bind(to: collectionCompanies.rx.items(cellIdentifier: ProductionCompaniesCollectionViewCell.identifier, cellType: ProductionCompaniesCollectionViewCell.self)) {row, model, cell in
            cell.company = model
        }.disposed(by: disposeBag)
        
        self.collectionCompanies.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.detailMovieModelView
            .productionCompanies
            .asDriver()
            .drive(onNext: {[unowned self] (companies) in
                let defaultHeight: CGFloat = 210.0
                if companies.count > 0 {
                    self.labelCompanies.text = "Companies"
                    self.companiesViewHeight.constant = defaultHeight
                } else {
                    self.labelCompanies.text = nil
                    self.companiesViewHeight.constant = 0.0
                }
                UIView.animate(withDuration: 0.2) {
                    self.companies.alpha = 1.0
                }
                self.scrollView.layoutIfNeeded()
        }).disposed(by: disposeBag)
    }
}

extension DetailMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
}
