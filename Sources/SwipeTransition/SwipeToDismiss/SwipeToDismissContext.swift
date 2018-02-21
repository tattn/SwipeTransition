//
//  SwipeToDismissContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180119.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

final class SwipeToDismissContext: Context<UIViewController>, ContextType {
    // Delegate Proxies (strong reference)
    var scrollViewDelegateProxies: [ScrollViewDelegateProxy] = []

    var previousGestureRecordDate = Date()
    var scrollAmountY: CGFloat = 0
    var scrollSpeed: CGFloat = 0
    var scrollVelocity: CGFloat {
        let interval = CGFloat(Date().timeIntervalSince(previousGestureRecordDate))
        return scrollSpeed / interval
    }

    func allowsTransitionFinish(swipeVelocity: CGFloat) -> Bool {
        let swipeSpeedCheck = SwipeToDismissConfiguration.shared.dismissSwipeSpeed.map { swipeVelocity > $0 } ?? false
        return interactiveTransition!.percentComplete > SwipeToDismissConfiguration.shared.dismissHeightRatio || swipeSpeedCheck
    }

    func velocity(recognizer: UIPanGestureRecognizer) -> CGPoint {
        guard let view = targetView else { return .zero }
        return recognizer.velocity(in: view)
    }

    func didStartTransition() {
        target?.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + SwipeToDismissConfiguration.shared.animationWaitTime) {
            guard let interactiveTransition = self.interactiveTransition else { return }
            interactiveTransition.update(interactiveTransition.percentComplete)
        }
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard let view = targetView, isEnabled else { return }
        updateTransition(withTranslationY: recognizer.translation(in: view).y)
    }

    func updateTransition(withTranslationY translationY: CGFloat) {
        guard let view = targetView, isEnabled else { return }
        interactiveTransition?.update(value: max(translationY, 0), maxValue: view.bounds.height)
    }
}
