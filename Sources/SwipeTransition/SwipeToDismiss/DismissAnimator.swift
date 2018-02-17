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
        return SwipeToDismissConfiguration.shared.transitionDuration
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

        let pausedTime = from.view.layer.convertTime(CACurrentMediaTime(), from: nil)
        from.view.layer.speed = 0.0
        from.view.layer.timeOffset = pausedTime

        // [workaround]
        // UIPercentDrivenInteractiveTransition.update() does not work at the moment of dismiss(animated:completion:)
        // Pause the animation for a while, to avoid the bugs
        DispatchQueue.main.asyncAfter(deadline: .now() + SwipeToDismissConfiguration.shared.animationWaitTime) {
            let pausedTime: CFTimeInterval = from.view.layer.timeOffset
            from.view.layer.speed = 1.0
            from.view.layer.timeOffset = 0.0
            from.view.layer.beginTime = 0.0
            let timeSincePause = from.view.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            from.view.layer.beginTime = timeSincePause
        }
    }

    func animationEnded(_ transitionCompleted: Bool) {
    }
}
