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

    weak var disabledScrollView: UIScrollView?

    // Delegate Proxies (strong reference)
    var scrollViewDelegateProxies: [ScrollViewDelegateProxy] = []


    var interactiveTransition: InteractiveTransition?

    var isEnabled = true
    var animating = false
    var transitioning: Bool { return interactiveTransition != nil }

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    var allowsTransitionStart: Bool {
        return !animating && isEnabled
    }

    func allowsTransitionFinish() -> Bool {
        return interactiveTransition!.percentComplete > SwipeToDismissConfiguration.shared.dismissHeightRatio
    }

    func startTransition() {
        guard allowsTransitionStart else { return }
        interactiveTransition = InteractiveTransition()
        viewController?.dismiss(animated: true, completion: nil)
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard let view = targetView, isEnabled else { return }
        let translation = recognizer.translation(in: view)
        updateTransition(withTranslationY: translation.y)
    }

    func updateTransition(withTranslationY translationY: CGFloat) {
        guard let view = targetView, isEnabled else { return }
        interactiveTransition?.update(value: translationY, maxValue: view.bounds.height)
    }

    func finishTransition() {
        interactiveTransition?.finish()
        interactiveTransition = nil
        disabledScrollView?.isScrollEnabled = true
    }

    func cancelTransition() {
        interactiveTransition?.cancel()
        interactiveTransition = nil
        disabledScrollView?.isScrollEnabled = true
        animating = false
    }

    func interactiveTransitionIfNeeded() -> InteractiveTransition? {
        return isEnabled ? interactiveTransition : nil
    }
}
