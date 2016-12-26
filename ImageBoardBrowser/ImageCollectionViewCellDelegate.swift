//
//  ImageCollectionViewCellDelegate.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 26/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCollectionViewCellDelegate: class {
    func imageLoadingWillStart()
    func imageLoadingDidStop()
}
