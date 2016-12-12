//
//  MainTabBarController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 12/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var panGesture: UIPanGestureRecognizer?
    
    var interactiveTransitioning: UIPercentDrivenInteractiveTransition?
    var isTransitioning = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        setupGestureRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupGestureRecognizer() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(swipped(sender:)))
        panGesture?.delegate = self
        view.addGestureRecognizer(panGesture!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func swipped(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let percent = fabs(translation.x / view.frame.width)
        switch sender.state {
        case .began:
            self.interactiveTransitioning = UIPercentDrivenInteractiveTransition()
            self.isTransitioning = true
            if velocity.x > 0 {
                selectedIndex -= 1
            }
            if velocity.x < 0 {
                selectedIndex += 1
            }
        case .changed:
            self.interactiveTransitioning?.update(percent)
        case .ended:
            if percent > 0.3 {
                self.interactiveTransitioning?.finish()
            } else {
                self.interactiveTransitioning?.cancel()
            }
            self.isTransitioning = false
        default:
            self.interactiveTransitioning?.cancel()
            self.isTransitioning = false
        }
    }
}

extension MainTabBarController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = gesture.velocity(in: view)
            if fabs(velocity.x) > fabs(velocity.y) {
                if velocity.x < 0 && selectedIndex < viewControllers!.count - 1 {
                    return true
                } else if velocity.x > 0 && selectedIndex > 0 {
                    return true
                }
            }
        }
        return false
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isTransitioning ? self.interactiveTransitioning : nil
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
