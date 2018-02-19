//
//  SwipeBackContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171227.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class SwipeBackContext: Context<UINavigationController>, ContextType {
    weak var disabledScrollView: UIScrollView?

    // Delegate Proxies (strong reference)
    var navigationControllerDelegateProxy: NavigationControllerDelegateProxy? {
        didSet {
            target?.delegate = navigationControllerDelegateProxy
        }
    }
    var scrollViewDelegateProxies: [ScrollViewDelegateProxy] = []

    override var allowsTransitionStart: Bool {
        guard let navigationController = target else { return false }
        return navigationController.viewControllers.count > 1 && super.allowsTransitionStart
    }

    func allowsTransitionFinish(recognizer: UIPanGestureRecognizer) -> Bool {
        guard let view = targetView else { return false }
        return recognizer.velocity(in: view).x > 0
    }

    func didStartTransition() {
        target?.popViewController(animated: true)
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard let view = targetView, isEnabled else { return }
        let translation = recognizer.translation(in: view)
        interactiveTransition?.update(value: translation.x, maxValue: view.bounds.width)
    }

    func didCancelTransition() {
        disabledScrollView?.isScrollEnabled = true
    }
}
