//
//  SwipeBackController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

// Allows to use in Objective-C
@objc public protocol SwipeBackControllerDelegate: class {
    @objc optional func backSwipeControllerStartTransition(context: UIViewControllerContextTransitioning)
    @objc optional func backSwipeControllerDidFinishTransition(context: UIViewControllerContextTransitioning)
    @objc optional func backSwipeControllerIsFirstPageOfPageViewController() -> Bool
}

@objcMembers
public final class SwipeBackController: NSObject {
    public weak var delegate: SwipeBackControllerDelegate? {
        didSet {
            animator.delegate = delegate
        }
    }

    public var isEnabled: Bool {
        get { return context.isEnabled }
        set { context.isEnabled = newValue }
    }
    
    private let animator = Animator()
    private let context: SwipeBackContext
    private let panGestureRecognizer = UIPanGestureRecognizer()

    public required init(navigationController: UINavigationController) {
        context = SwipeBackContext(navigationController: navigationController)

        super.init()

        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self

        navigationController.view.addGestureRecognizer(panGestureRecognizer)
        setNavigationControllerDelegate(navigationController.delegate)
    }

    deinit {
        panGestureRecognizer.removeTarget(self, action: #selector(handlePanGesture(_:)))
        context.navigationController?.view.removeGestureRecognizer(panGestureRecognizer)
    }

    public func setNavigationControllerDelegate(_ delegate: UINavigationControllerDelegate?) {
        context.navigationControllerDelegateProxy = NavigationControllerDelegateProxy(delegates: [self] + (delegate.map { [$0] } ?? []) )
    }

    public func setScrollViews(_ scrollViews: [UIScrollView]) {
        context.scrollViewDelegateProxies = scrollViews
            .map { ScrollViewDelegateProxy(delegates: [self] + ($0.delegate.map { [$0] } ?? [])) }
        zip(scrollViews, context.scrollViewDelegateProxies).forEach { $0.delegate = $1 }
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            context.startTransition()
        case .changed:
            context.updateTransition(recognizer: recognizer)
        case .ended:
            if context.allowsTransitionFinish(recognizer: recognizer) {
                context.finishTransition()
            } else {
                fallthrough
            }
        case .cancelled:
            context.cancelTransition()
        default:
            break
        }
    }
}

extension SwipeBackController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return context.allowsTransitionStart
    }
}

extension SwipeBackController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return operation == .pop && context.isEnabled ? animator : nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return context.interactiveTransitionIfNeeded()
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated, context.isEnabled {
            context.animating = true
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        context.animating = false
        panGestureRecognizer.isEnabled = navigationController.viewControllers.count > 1
    }
}

extension SwipeBackController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let isFirstPage = delegate?.backSwipeControllerIsFirstPageOfPageViewController?(), isFirstPage,
            scrollView.contentOffset.x <= UIScreen.main.bounds.size.width {
            scrollView.isScrollEnabled = false
            context.disabledScrollView = scrollView
        }
    }
}
