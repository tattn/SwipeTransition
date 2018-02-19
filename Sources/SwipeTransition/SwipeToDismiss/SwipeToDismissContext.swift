//
//  SwipeToDismissContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180119.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

final class SwipeToDismissContext: Context<UIViewController> {
    // Delegate Proxies (strong reference)
    var scrollViewDelegateProxies: [ScrollViewDelegateProxy] = []

    var transitioning: Bool { return interactiveTransition != nil }

    var scrollAmountY: CGFloat = 0

    var allowsTransitionStart: Bool {
        return !transitioning && isEnabled
    }

    func allowsTransitionFinish() -> Bool {
        return interactiveTransition!.percentComplete > SwipeToDismissConfiguration.shared.dismissHeightRatio
    }

    func translation(recognizer: UIPanGestureRecognizer) -> CGPoint {
        guard let view = targetView else { return .zero }
        return recognizer.translation(in: view)
    }

    func startTransition() {
        guard allowsTransitionStart else { return }
        interactiveTransition = InteractiveTransition()
        target?.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + SwipeToDismissConfiguration.shared.animationWaitTime) {
            guard let interactiveTransition = self.interactiveTransition else { return }
            interactiveTransition.update(interactiveTransition.percentComplete)
        }
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard isEnabled else { return }
        updateTransition(withTranslationY: translation(recognizer: recognizer).y)
    }

    func updateTransition(withTranslationY translationY: CGFloat) {
        guard let view = targetView, isEnabled else { return }
        interactiveTransition?.update(value: max(translationY, 0), maxValue: view.bounds.height)
    }

    func finishTransition() {
        interactiveTransition?.finish()
        interactiveTransition = nil
    }

    func cancelTransition() {
        interactiveTransition?.cancel()
        interactiveTransition = nil
    }
}
