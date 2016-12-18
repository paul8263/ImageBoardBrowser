//
//  FavouriteImageCollectionViewCell.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 5/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class FavouriteImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.sd_cancelCurrentImageLoad()
    }
    
    func loadImage(urlString: String) {
        self.imageView.sd_setImage(with: URL(string: urlString)!, placeholderImage: UIImage(named: "placeholder"))
    }
}
