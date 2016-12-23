//
//  UIview+LoadingIndicatorViewExtension.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 23/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoadingIndicatorView() {
        let rect = CGRect(x: CGFloat(view.bounds.width) / 2, y: CGFloat(view.bounds.height) / 2, width: CGFloat(50.0), height: CGFloat(50.0))
        let indicatorView = LoadingIndicatorView(frame: rect)
        indicatorView.tag = 1000
        view.addSubview(indicatorView)
    }
    
    func hideLoadingIndicatorView() {
        view.viewWithTag(1000)?.removeFromSuperview()
    }
}
