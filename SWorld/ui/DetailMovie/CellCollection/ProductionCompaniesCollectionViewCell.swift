//
//  ProductionCompaniesCollectionViewCell.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 16/11/21.
//

import UIKit
import RxSwift
import RxCocoa

class ProductionCompaniesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    let disposeBag = DisposeBag()
    
    var company: ProductionCompany? {
        didSet {
            if let company = self.company {
                if let logoPath = company.logoPath {
                ImageManager.shared.rx_image(path: logoPath)
                    .drive(self.logoImage.rx.image)
                    .disposed(by: disposeBag)
                }
                self.name.text = company.name
            }
        }
    }
}
