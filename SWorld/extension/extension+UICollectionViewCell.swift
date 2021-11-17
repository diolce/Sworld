//
//  extension+UICollectionViewCell.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 16/11/21.
//

import UIKit

extension UICollectionViewCell {
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier:String {
        return String(describing: self)
    }
}
