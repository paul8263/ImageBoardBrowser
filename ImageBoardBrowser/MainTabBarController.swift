//
//  MainTabBarController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 12/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension MainTabBarController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let containerView = transitionContext.containerView
        
        let fromFrameStart = transitionContext.initialFrame(for: fromVC)
        let toFrameEnd = transitionContext.finalFrame(for: toVC)
        
        let fromIndex = viewControllers!.index(of: fromVC)!
        let toIndex = viewControllers!.index(of: toVC)!
        
        let factor = fromIndex < toIndex ? CGFloat(1) : CGFloat(-1)
        
        var fromFrameEnd = fromFrameStart
        fromFrameEnd.origin.x -= fromFrameStart.width * factor
        
        var toFrameStart = toFrameEnd
        toFrameStart.origin.x += toFrameEnd.width * factor
        
        toView.frame = toFrameStart
        containerView.addSubview(toView)
//        Set the background color during animation
        containerView.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            fromView.frame = fromFrameEnd
            toView.frame = toFrameEnd
        }, completion: { (finished) -> Void in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }
}
