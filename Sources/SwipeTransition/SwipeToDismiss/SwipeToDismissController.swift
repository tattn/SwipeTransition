//
//  SwipeToDismissController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180119.
//  Copyright © 2018年 tattn. All rights reserved.
//

@objcMembers
public final class SwipeToDismissController: NSObject {
    public var onStartTransition: ((UIViewControllerContextTransitioning) -> Void)?
    public var onFinishTransition: ((UIViewControllerContextTransitioning) -> Void)?

    public var isEnabled: Bool {
        get { return context.isEnabled }
        set { context.isEnabled = newValue }
    }

    private var animator = DismissAnimator()
    private let context: SwipeToDismissContext
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private var scrollAmountY: CGFloat = 0

    public init(viewController: UIViewController) {
        context = SwipeToDismissContext(viewController: viewController)

        super.init()
        animator.parent = self

        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
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
        context.viewController!.view.addGestureRecognizer(panGestureRecognizer)
    }

    public func setScrollViews(_ scrollViews: [UIScrollView]) {
        context.scrollViewDelegateProxies = scrollViews
            .map { ScrollViewDelegateProxy(delegates: [self] + ($0.delegate.map { [$0] } ?? [])) }
        zip(scrollViews, context.scrollViewDelegateProxies).forEach { $0.delegate = $1 }
        if #available(iOS 11, *) {
            scrollViews.forEach { $0.contentInsetAdjustmentBehavior = .never }
        }
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            context.startTransition()
        case .changed:
            context.updateTransition(recognizer: recognizer)
        case .ended:
            if context.allowsTransitionFinish() {
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
}

extension SwipeToDismissController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator(parent: self)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return context.interactiveTransitionIfNeeded()
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}

extension SwipeToDismissController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if context.transitioning {
            scrollAmountY += -scrollView.contentOffset.y
            scrollView.contentOffset.y = 0
            context.updateTransition(withTranslationY: scrollAmountY)

            if scrollAmountY <= 0 {
                scrollAmountY = 0
                context.cancelTransition()
            }
        } else if scrollView.contentOffset.y < 0 {
            context.startTransition()
            scrollAmountY = -scrollView.contentOffset.y
            scrollView.contentOffset.y = 0
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
        scrollAmountY = 0
    }
}
