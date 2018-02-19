//
//  SwipeToDismissController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180119.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation

@objcMembers
public final class SwipeToDismissController: NSObject {
    public var onStartTransition: ((UIViewControllerContextTransitioning) -> Void)?
    public var onFinishTransition: ((UIViewControllerContextTransitioning) -> Void)?

    public var isEnabled: Bool {
        get { return context.isEnabled }
        set { context.isEnabled = newValue }
    }

    private lazy var animator = DismissAnimator(parent: self)
    private let context: SwipeToDismissContext
    private lazy var panGestureRecognizer = OneFingerDirectionalPanGestureRecognizer(direction: .vertical, target: self, action: #selector(handlePanGesture(_:)))

    public init(viewController: UIViewController) {
        context = SwipeToDismissContext(target: viewController)
        super.init()

        panGestureRecognizer.delegate = self

        viewController.transitioningDelegate = self
        if viewController.isViewLoaded {
            addSwipeGesture()
        }
    }

    deinit {
        panGestureRecognizer.view?.removeGestureRecognizer(panGestureRecognizer)
    }

    public func addSwipeGesture() {
        context.target!.view.addGestureRecognizer(panGestureRecognizer)
    }

    public func setScrollViews(_ scrollViews: [UIScrollView]) {
        context.scrollViewDelegateProxies = scrollViews
            .map { ScrollViewDelegateProxy(delegates: [self] + ($0.delegate.map { [$0] } ?? [])) }
        zip(scrollViews, context.scrollViewDelegateProxies).forEach { $0.delegate = $1 }
    }

    @objc private func handlePanGesture(_ recognizer: OneFingerDirectionalPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            context.startTransition()
        case .changed:
            context.updateTransition(recognizer: recognizer)
        case .ended:
            if context.allowsTransitionFinish() {
                context.finishTransition()
            } else {
                if let speed = SwipeToDismissConfiguration.shared.dismissSwipeSpeed,
                    context.translation(recognizer: recognizer).y >= speed {
                    context.finishTransition()
                } else {
                    fallthrough
                }
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
}

extension SwipeToDismissController: UIViewControllerTransitioningDelegate {
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return context.interactiveTransitionIfNeeded()
    }
}

extension SwipeToDismissController: UIScrollViewDelegate {
    private func baseY(of scrollView: UIScrollView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return -scrollView.safeAreaInsets.top
        } else {
            return 0
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let baseY = self.baseY(of: scrollView)
        if context.transitioning {
            context.scrollAmountY += -(scrollView.contentOffset.y - baseY)
            scrollView.contentOffset.y = baseY
            context.updateTransition(withTranslationY: context.scrollAmountY - baseY)
        } else if scrollView.contentOffset.y < baseY, !scrollView.isDecelerating {
            context.startTransition()
            context.scrollAmountY = scrollView.contentOffset.y
            scrollView.contentOffset.y = baseY
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if context.transitioning {
            if context.allowsTransitionFinish() {
                context.finishTransition()
            } else {
                context.cancelTransition()
            }
        }
        context.scrollAmountY = scrollView.contentOffset.y
    }
}
