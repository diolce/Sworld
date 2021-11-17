//
//  MovieTableViewCell.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import UIKit
import RxSwift

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    let disposeBag = DisposeBag()
    
    var movie: Movie? {
        didSet {
            if let movie = self.movie {
                if let posterPath = movie.posterPath {
                ImageManager.shared.rx_image(path: posterPath)
                    .drive(movieImage.rx.image)
                    .disposed(by: disposeBag)
                }
                title.text = movie.originalTitle
                overview.text = movie.overview
            }
        }
    }
}
