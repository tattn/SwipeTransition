//
//  SwipeBackContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171227.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class SwipeBackContext: Context<UINavigationController>, ContextType {
    // Delegate Proxies (strong reference)
    var navigationControllerDelegateProxy: NavigationControllerDelegateProxy? {
        didSet {
            target?.delegate = navigationControllerDelegateProxy
        }
    }

    weak var pageViewControllerPanGestureRecognizer: UIPanGestureRecognizer?

    override var allowsTransitionStart: Bool {
        guard let navigationController = target else { return false }
        return navigationController.viewControllers.count > 1 && super.allowsTransitionStart
    }

    func allowsTransitionFinish(recognizer: UIPanGestureRecognizer) -> Bool {
        guard let view = targetView else { return false }
        let percent = max(recognizer.translation(in: view).x, 0) / view.frame.width
        // Continue if drag more than 50% of screen width or velocity is higher than 1000
        return percent > 0.5 || recognizer.velocity(in: view).x > 1000
    }

    func didStartTransition() {
        target?.popViewController(animated: true)
    }

    func updateTransition(recognizer: UIPanGestureRecognizer) {
        guard let view = targetView, isEnabled else { return }
        let translation = recognizer.translation(in: view)
        interactiveTransition?.update(value: translation.x, maxValue: view.bounds.width)
    }
}
