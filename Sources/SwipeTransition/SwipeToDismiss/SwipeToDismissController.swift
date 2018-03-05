//
//  SwipeToDismissController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180119.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation
import WebKit

@objcMembers
public final class SwipeToDismissController: NSObject {
    public var onStartTransition: ((UIViewControllerContextTransitioning) -> Void)?
    public var onFinishTransition: ((UIViewControllerContextTransitioning) -> Void)?

    public var isEnabled: Bool {
        get { return context.isEnabled }
        set {
            context.isEnabled = newValue
            panGestureRecognizer.isEnabled = newValue
        }
    }

    private lazy var animator = DismissAnimator(parent: self)
    private let context: SwipeToDismissContext
    private lazy var panGestureRecognizer = OneFingerDirectionalPanGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePanGesture(_:)))

    public init(viewController: UIViewController) {
        let targetViewController = viewController.navigationController ?? viewController
        context = SwipeToDismissContext(target: targetViewController)
        super.init()

        panGestureRecognizer.delegate = self
        targetViewController.transitioningDelegate = self

        if targetViewController.isViewLoaded {
            addSwipeGesture()
        }
    }

    public convenience init(navigationController: UINavigationController) {
        if let rootViewController = navigationController.viewControllers.first {
            rootViewController.swipeToDismiss = nil
        }
        self.init(viewController: navigationController)
    }

    deinit {
        panGestureRecognizer.view?.removeGestureRecognizer(panGestureRecognizer)
    }

    public func addSwipeGesture() {
        context.targetView.unsafelyUnwrapped.addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        if let scrollView = context.observedScrollView, let targetView = context.targetView {
            if scrollView.contentOffset.y <= baseY(of: scrollView), panGestureRecognizer.translation(in: targetView).y > 0 {
                scrollView.contentOffset.y = baseY(of: scrollView)
                scrollView.panGestureRecognizer.state = .failed
                context.observedScrollView = nil
                if recognizer.state != .began {
                    context.startTransition()
                }
            } else if !context.transitioning {
                return
            }
        }

        switch recognizer.state {
        case .began:
            context.startTransition()
        case .changed:
            context.updateTransition(recognizer: recognizer)
        case .ended:
            if context.allowsTransitionFinish(swipeVelocity: context.velocity(recognizer: recognizer).y) {
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

extension SwipeToDismissController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return context.allowsTransitionStart
    }

    private func baseY(of scrollView: UIScrollView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return -scrollView.safeAreaInsets.top
        } else {
            return -scrollView.contentInset.top
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            let scrollViewType = type(of: scrollView)
            let superViewType = scrollView.superview.map { type(of: $0) }
            if scrollViewType === UIScrollView.self // filter UITableViewWrapperView and so on...
                || scrollViewType === UITableView.self
                || scrollViewType === UICollectionView.self
                || superViewType === WKWebView.self
                || superViewType === UIWebView.self {
                    context.observedScrollView = scrollView
            }
        }
        return true
    }
}

extension SwipeToDismissController: UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return context.isEnabled && context.interactiveTransition != nil ? animator : nil
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return context.interactiveTransitionIfNeeded()
    }
}
