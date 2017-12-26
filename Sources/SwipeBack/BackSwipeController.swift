//
//  BackSwipeController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

// TODO: Change delegate to closure
@objc
public protocol BackSwipeControllerDelegate: class {
    @objc optional func backSwipeControllerStartTransition(context: UIViewControllerContextTransitioning)
    @objc optional func backSwipeControllerDidFinishTransition(context: UIViewControllerContextTransitioning)
    @objc optional func backSwipeControllerIsFirstPageOfPageViewController() -> Bool
}

//public extension BackSwipeControllerDelegate {
//    public func backSwipeControllerStartTransition(context: UIViewControllerContextTransitioning) {}
//    public func backSwipeControllerDidFinishTransition(context: UIViewControllerContextTransitioning) {}
//    public func backSwipeControllerIsFirstPageOfPageViewController() -> Bool { return false }
//}

@objcMembers
public final class BackSwipeController: NSObject {
    public var delegate: BackSwipeControllerDelegate? {
        didSet {
            animator.delegate = delegate
        }
    }

    public var isEnabled = true
    public private(set) weak var navigationController: UINavigationController?
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let animator = Animator()

    private var animating = false
    private var interactiveTransition: InteractiveTransition?

    private var proxy: NavigationControllerDelegateProxy? // strong reference

    private var scrollViewDelegateProxy: ScrollViewDelegateProxy? // strong reference
    private weak var disabledScrollView: UIScrollView?

    private var previousContentOffsetX: CGFloat = 0

    public init(navigationController: UINavigationController) {
        super.init()
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self

        navigationController.view.addGestureRecognizer(panGestureRecognizer)
        self.navigationController = navigationController
        setNavigationControllerDelegate(navigationController.delegate)
    }

    deinit {
        panGestureRecognizer.removeTarget(self, action: #selector(handlePanGesture(_:)))
        navigationController?.view.removeGestureRecognizer(panGestureRecognizer)
    }

    public func setNavigationControllerDelegate(_ delegate: UINavigationControllerDelegate?) {
        proxy = NavigationControllerDelegateProxy(delegates: [self] + (delegate.map { [$0] } ?? []) )
        navigationController?.delegate = proxy
    }

    public func setScrollViews(_ scrollViews: [UIScrollView]) {
        let delegates = scrollViews.flatMap { $0.delegate }
        scrollViewDelegateProxy = ScrollViewDelegateProxy(delegates: [self] + delegates)
        scrollViews.forEach { $0.delegate = scrollViewDelegateProxy }
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let navigationController = navigationController, let view = navigationController.view, isEnabled else { return }

        switch recognizer.state {
        case .began:
            if navigationController.viewControllers.count > 1, !animating {
                interactiveTransition = InteractiveTransition()
                navigationController.popViewController(animated: true)
            }
        case .changed:
            let translation = recognizer.translation(in: view)
            interactiveTransition?.update(value: translation.x, maxValue: view.bounds.width)
        case .ended:
            if recognizer.velocity(in: view).x > 0 {
                interactiveTransition?.finish()
                interactiveTransition = nil
                disabledScrollView?.isScrollEnabled = true
            } else {
                fallthrough
            }
        case .cancelled:
            interactiveTransition?.cancel()
            interactiveTransition = nil
            animating = false
            disabledScrollView?.isScrollEnabled = true
        default:
            break
        }
    }
}

extension BackSwipeController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.map { $0.viewControllers.count > 1 } ?? false
    }
}

extension BackSwipeController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return operation == .pop && isEnabled ? animator : nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isEnabled ? interactiveTransition : nil
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated, isEnabled {
            animating = true
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        animating = false
        panGestureRecognizer.isEnabled = navigationController.viewControllers.count > 1
    }
}

extension BackSwipeController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = delegate else { return }
        if delegate.backSwipeControllerIsFirstPageOfPageViewController?() == true,
            scrollView.contentOffset.x <= UIScreen.main.bounds.size.width {
            scrollView.isScrollEnabled = false
            disabledScrollView = scrollView
        }
    }
}
