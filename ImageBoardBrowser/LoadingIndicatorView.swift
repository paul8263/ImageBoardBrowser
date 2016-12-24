//
//  LoadingIndicatorView.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 23/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        let layer = CAReplicatorLayer()
        layer.bounds = bounds
        layer.backgroundColor = UIColor(white: 0.2, alpha: 1).cgColor
        layer.cornerRadius = 2
        layer.masksToBounds = true
        
        self.layer.addSublayer(layer)
        
        let dot = CALayer()
        let dotWidth = bounds.width / 11
        dot.frame = CGRect(x: dotWidth, y: (bounds.height - dotWidth) / 2, width: dotWidth, height: dotWidth)
        dot.backgroundColor = UIColor(white: 0.8, alpha: 1).cgColor
        dot.borderColor = UIColor.black.cgColor
        dot.borderWidth = 1
        dot.cornerRadius = bounds.width / 22
        
        dot.transform = CATransform3DMakeScale(2, 2, 2)
        
        layer.addSublayer(dot)
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = CATransform3DMakeScale(2, 2, 2)
        animation.toValue = CATransform3DMakeScale(0.2, 0.2, 0.2)
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        dot.add(animation, forKey: nil)
        
        layer.instanceCount = 5
        layer.instanceDelay = 0.3
        layer.instanceTransform = CATransform3DMakeTranslation(dotWidth * 2, 0, 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
