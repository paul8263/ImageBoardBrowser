//
//  ImageCollectionViewCell.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.sd_cancelCurrentImageLoad()
    }
    
    func loadImage(url: URL) {
        self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
}
