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
    
    weak var delegate: ImageCollectionViewCellDelegate?
    var hasStartedDownloading: Bool = false
    
    override func awakeFromNib() {
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.sd_cancelCurrentImageLoad()
        if hasStartedDownloading {
            delegate?.imageLoadingDidStop()
        }
        hasStartedDownloading = false
    }
    
    func loadImage(url: URL) {
        delegate?.imageLoadingWillStart()
        hasStartedDownloading = true
        
        self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: [.allowInvalidSSLCertificates], completed: { (image, error, cacheType, url) in
            if self.hasStartedDownloading {
                self.delegate?.imageLoadingDidStop()
            }
            self.hasStartedDownloading = false
        })
    }
}
