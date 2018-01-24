//
//  DismissAnimator.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180119.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

final class DismissAnimator: NSObject {
    private weak var parent: SwipeToDismissController!
    required init(parent: SwipeToDismissController) {
        super.init()
        self.parent = parent
    }
}

extension DismissAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return SwipeBackConfiguration.shared.transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let from = transitionContext.viewController(forKey: .from) else { return }

        parent.onStartTransition?(transitionContext)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveLinear,
            animations: {
                from.view.transform = CGAffineTransform(translationX: 0, y: from.view.frame.height)
        }, completion: { [weak self] _ in
            from.view.transform = .identity
            self?.parent.onFinishTransition?(transitionContext)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    func animationEnded(_ transitionCompleted: Bool) {
    }
}
