//
//  CollectionViewCell.swift
//  Davigram-InstagramProject
//
//  Created by David Lin on 3/10/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    public func configureCell(for photo: Photo) {
        cellImage.kf.setImage(with: URL(string: photo.photoURL))
    }
}


