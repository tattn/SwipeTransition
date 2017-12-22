//
//  Animator.swift
//  SwipeBackable
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

public final class Animator: NSObject {
    public weak var delegate: SwipeBackControllerDelegate?
    private weak var toViewController: UIViewController?
}

extension Animator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SwipeBackableConfiguration.shared.transitionDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.viewController(forKey: .to),
            let from = transitionContext.viewController(forKey: .from) else { return }
        transitionContext.containerView.insertSubview(to.view, belowSubview: from.view)
        to.view.frame = transitionContext.containerView.frame

        // parallax effect
        to.view.transform.tx = -transitionContext.containerView.bounds.width * SwipeBackableConfiguration.shared.parallaxFactor

        // dim the back view
        let dimmedView = UIView(frame: to.view.bounds)
        dimmedView.backgroundColor = UIColor(white: 0, alpha: SwipeBackableConfiguration.shared.backViewDimness)
        to.view.addSubview(dimmedView)

        delegate?.swipeBackControllerStartTransition(context: transitionContext)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear,
            animations: {
                to.view.transform = .identity
                from.view.transform = CGAffineTransform(translationX: to.view.frame.width, y: 0)
                dimmedView.alpha = 0
            }, completion: { [weak self] _ in
                dimmedView.removeFromSuperview()
                from.view.transform = .identity
                self?.delegate?.swipeBackControllerDidFinishTransition(context: transitionContext)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )

        toViewController = to
    }

    public func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            toViewController?.view.transform = .identity
        }
    }
}
