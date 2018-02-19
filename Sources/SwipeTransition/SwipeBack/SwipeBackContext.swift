//
//  SwipeBackContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171227.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class SwipeBackContext: Context<UINavigationController> {
    weak var disabledScrollView: UIScrollView?

    // Delegate Proxies (strong reference)
    var navigationControllerDelegateProxy: NavigationControllerDelegateProxy? {
        didSet {
            target?.delegate = navigationControllerDelegateProxy
        }
    }
    var scrollViewDelegateProxies: [ScrollViewDelegateProxy] = []

    var transitioning = false

    var allowsTransitionStart: Bool {
        guard let navigationController = target else { return false }
        return navigationController.viewControllers.count > 1 && !transitioning && isEnabled
    }

    func allowsTransitionFinish(recognizer: UIPanGestureRecognizer) -> Bool {
        guard let view = targetView else { return false }
        return recognizer.velocity(in: view).x > 0
    }

    func startTransition() {
        guard allowsTransitionStart else { return }
        interactiveTransition = InteractiveTransition()
        target?.popViewController(animated: true)
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard let view = targetView, isEnabled else { return }
        let translation = recognizer.translation(in: view)
        interactiveTransition?.update(value: translation.x, maxValue: view.bounds.width)
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
        transitioning = false
    }
}
