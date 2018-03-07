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

    public var isEnabled: Bool = true {
        didSet {
            context?.isEnabled = isEnabled
            panGestureRecognizer.isEnabled = isEnabled
        }
    }

    private lazy var animator = DismissAnimator(parent: self)
    private var context: SwipeToDismissContext!
    private let panGestureRecognizer = OneFingerDirectionalPanGestureRecognizer(direction: .vertical)

    public override init() {
        super.init()
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
    }

    deinit {
        removeTargetViewController()
    }

    public func setTarget(viewController: UIViewController) {
        let targetViewController = viewController.navigationController ?? viewController
        context = SwipeToDismissContext(target: targetViewController)
        context.isEnabled = isEnabled

        targetViewController.transitioningDelegate = self
        panGestureRecognizer.delegate = self

        targetViewController.view.addGestureRecognizer(panGestureRecognizer)
    }

    public func removeTargetViewController() {
        context?.target?.transitioningDelegate = nil
        context = nil
        panGestureRecognizer.view?.removeGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
//        precondition(self === context.target!.transitioningDelegate!)

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
            } else {
                gestureRecognizer.state = .failed
                return false
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
