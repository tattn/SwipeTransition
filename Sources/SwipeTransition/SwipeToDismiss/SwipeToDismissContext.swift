//
//  SwipeToDismissContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180119.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

final class SwipeToDismissContext {
    private(set) weak var viewController: UIViewController?
    var targetView: UIView? { return viewController?.view }

    // Delegate Proxies (strong reference)
    var scrollViewDelegateProxies: [ScrollViewDelegateProxy] = []


    var interactiveTransition: InteractiveTransition?

    var isEnabled = true
    var transitioning: Bool { return interactiveTransition != nil }

    var scrollAmountY: CGFloat = 0

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    var allowsTransitionStart: Bool {
        return !transitioning && isEnabled
    }

    func allowsTransitionFinish() -> Bool {
        return interactiveTransition!.percentComplete > SwipeToDismissConfiguration.shared.dismissHeightRatio
    }

    func startTransition() {
        guard allowsTransitionStart else { return }
        let interactiveTransition = InteractiveTransition()
        self.interactiveTransition = interactiveTransition
        viewController?.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + SwipeToDismissConfiguration.shared.animationWaitTime) {
            interactiveTransition.update(interactiveTransition.percentComplete)
        }
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard let view = targetView, isEnabled else { return }
        let translation = recognizer.translation(in: view)
        updateTransition(withTranslationY: translation.y)
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

    func interactiveTransitionIfNeeded() -> InteractiveTransition? {
        return isEnabled ? interactiveTransition : nil
    }
}
