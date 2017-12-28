//
//  SwipeBackContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171227.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class SwipeBackContext {
    private(set) weak var navigationController: UINavigationController?
    var targetView: UIView? { return navigationController?.view }

    weak var disabledScrollView: UIScrollView?


    // Delegate Proxies (strong reference)
    var navigationControllerDelegateProxy: NavigationControllerDelegateProxy? {
        didSet {
            navigationController?.delegate = navigationControllerDelegateProxy
        }
    }
    var scrollViewDelegateProxies: [ScrollViewDelegateProxy] = []


    var interactiveTransition: InteractiveTransition?

    var isEnabled = true
    var animating = false

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    var allowsTransitionStart: Bool {
        guard let navigationController = navigationController else { return false }
        return navigationController.viewControllers.count > 1 && !animating && isEnabled
    }

    func allowsTransitionFinish(recognizer: UIPanGestureRecognizer) -> Bool {
        guard let view = targetView else { return false }
        return recognizer.velocity(in: view).x > 0
    }

    func startTransition() {
        guard allowsTransitionStart else { return }
        interactiveTransition = InteractiveTransition()
        navigationController?.popViewController(animated: true)
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
        animating = false
    }

    func interactiveTransitionIfNeeded() -> InteractiveTransition? {
        return isEnabled ? interactiveTransition : nil
    }
}
