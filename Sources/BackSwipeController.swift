//
//  BackSwipeController.swift
//  BackSwipeable
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

public protocol BackSwipeControllerDelegate: class {
    func backSwipeControllerStartTransition(context: UIViewControllerContextTransitioning)
    func backSwipeControllerDidFinishTransition(context: UIViewControllerContextTransitioning)
}

public extension BackSwipeControllerDelegate {
    public func backSwipeControllerStartTransition(context: UIViewControllerContextTransitioning) {}
    public func backSwipeControllerDidFinishTransition(context: UIViewControllerContextTransitioning) {}
}

public final class BackSwipeController: NSObject {
    var delegate: BackSwipeControllerDelegate? {
        get { return animator.delegate }
        set { animator.delegate = newValue }
    }

    public private(set) weak var navigationController: UINavigationController?
    private let panGestureRecognizer = UIPanGestureRecognizer()
    private let animator = Animator()

    private var animating = false
    private var interactiveTransition: InteractiveTransition!

    public init(navigationController: UINavigationController) {
        super.init()
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self

        navigationController.delegate = self
        navigationController.view.addGestureRecognizer(panGestureRecognizer)
        self.navigationController = navigationController
    }

    deinit {
        panGestureRecognizer.removeTarget(self, action: #selector(handlePanGesture(_:)))
        navigationController?.view.removeGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let navigationController = navigationController, let view = navigationController.view else { return }

        switch recognizer.state {
        case .began:
            if navigationController.viewControllers.count > 1, !animating {
                interactiveTransition = InteractiveTransition()
                navigationController.popViewController(animated: true)
            }
        case .changed:
            let translation = recognizer.translation(in: view)
            interactiveTransition.update(value: translation.x, maxValue: view.bounds.width)
        case .ended:
            if recognizer.velocity(in: view).x > 0 {
                interactiveTransition.finish()
                interactiveTransition = nil
            } else {
                fallthrough
            }
        case .cancelled:
            interactiveTransition.cancel()
            interactiveTransition = nil
            animating = false
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
        return operation == .pop ? animator : nil
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if animated {
            animating = true
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        animating = false
        panGestureRecognizer.isEnabled = navigationController.viewControllers.count > 1
    }
}
