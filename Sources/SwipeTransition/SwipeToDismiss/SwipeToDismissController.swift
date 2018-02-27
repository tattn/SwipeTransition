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
        if let navigationController = viewController.navigationController {
            context = SwipeToDismissContext(target: navigationController)
        } else {
            context = SwipeToDismissContext(target: viewController)
        }
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

    @objc private func handlePanGesture(_ recognizer: OneFingerDirectionalPanGestureRecognizer) {
        if let scrollView = context.observedScrollView {
            if scrollView.contentOffset.y <= baseY(of: scrollView), panGestureRecognizer.translation(in: context.targetView!).y > 0 {
                scrollView.panGestureRecognizer.state = .failed
                scrollView.contentOffset.y = baseY(of: scrollView)
                context.observedScrollView = nil
                recognizer.setTranslation(.zero, in: context.targetView!)
                if recognizer.state != .began {
                    context.startTransition()
                }
            } else {
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
        context.previousGestureRecordDate = Date()
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
            return 0
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let scrollView = otherGestureRecognizer.view as? UIScrollView {
            if scrollView.contentOffset.y < baseY(of: scrollView), panGestureRecognizer.translation(in: context.targetView!).y > 0 {
                otherGestureRecognizer.state = .failed
            } else {
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
