//
//  SwipeToDismissController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171223.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

public class SwipeToDismissController: NSObject {

    public weak var delegate: UIScrollViewDelegate? {
        didSet {
            var delegates: [UIScrollViewDelegate] = [self]
            delegate.map { delegates.append($0) }
            proxy = ScrollViewDelegateProxy(delegates: delegates)
            scrollView?.delegate = proxy
        }
    }

    private var dragging = false
    private var previousContentOffsetY: CGFloat = 0.0

    private var viewPositionY: CGFloat = 0.0
    private let viewOriginY: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.statusBarFrame.height
        } else {
            return 0
        }
    }()

    public weak var viewControllerToDismiss: UIViewController?
    private var target: UIViewController? {
        return viewControllerToDismiss?.navigationController ?? viewControllerToDismiss
    }

    public weak var navigationBar: UIView? {
        didSet {
            if let navigationBar = navigationBar {
                if let old = oldValue, let panGesture = panGestures.first(where: { old == $0.view }) {
                    old.removeGestureRecognizer(panGesture)
                }
                addGesture(to: navigationBar)
            }
        }
    }

    public weak var scrollView: UIScrollView? {
        didSet {
            delegate = scrollView?.delegate
        }
    }
    private var proxy: ScrollViewDelegateProxy? // strong reference

    private var panGestures: [UIPanGestureRecognizer] = []

    public init?(view: UIView) {
        guard let viewController = view.viewController else {
            assertionFailure("the view doesn't belong to a view controller.")
            return nil
        }
        super.init()
        commonInit(viewController: viewController)
        addGesture(to: view)
    }

    private func commonInit(viewController: UIViewController) {
        viewControllerToDismiss = viewController
        navigationBar = viewController.navigationController?.navigationBar
    }

    deinit {
        panGestures.forEach { $0.view?.removeGestureRecognizer($0) }
    }

    private func dismiss() {
        proxy = nil
        target?.dismiss(animated: true, completion: nil)
    }

    private func addGesture(to view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(gesture)
        panGestures.append(gesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            startDragging()
        case .changed:
            let offsetY = gesture.translation(in: gesture.view).y
            updateView(withOffset: offsetY)
            gesture.setTranslation(.zero, in: gesture.view)
        case .ended:
            finishDragging(withVelocity: .zero)
        default:
            break
        }
    }

    private func startDragging() {
        guard let view = target?.view else { return }
        dragging = true
        view.layer.removeAllAnimations()
        viewPositionY = viewOriginY

        // [Workaround] I'd like to know if there is a better way.
        // For the first time, when the view.frame.origin.y is 0, the top of the screen is the origin,
        // but when scrolling, the bottom of the status bar becomes the origin.
        // So adjust the origin in advance to scroll smoothly.
        view.frame.origin.y = viewOriginY + 0.01
        view.layoutIfNeeded()
        view.frame.origin.y = viewOriginY
    }

    private func updateView(withOffset offset: CGFloat) {
        guard let view = target?.view else { return }
        viewPositionY += offset
        view.frame.origin.y = max(viewOriginY, viewPositionY)
    }

    private func finishDragging(withVelocity velocity: CGPoint) {
        guard let view = target?.view else { return }
        let originY = view.frame.origin.y
        let heightToDismiss = view.frame.height * SwipeToDismissConfiguration.shared.dismissHeightRatio
        if originY > heightToDismiss || originY > 0 && velocity.y < 0 {
            dismiss()
        } else if originY != viewOriginY {
            UIView.perform(.delete, on: [], options: [.allowUserInteraction], animations: { [weak self] in
                view.frame.origin.y = self?.viewOriginY ?? 0
            }, completion: { _ in
            })
        }
        viewPositionY = viewOriginY
        dragging = false
    }
}

extension SwipeToDismissController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard dragging, let targetView = target?.view else { return }
        let offsetDiff = previousContentOffsetY - scrollView.contentOffset.y
        let contentInsetTop = scrollView.contentInset.top
        if scrollView.contentOffset.y < -contentInsetTop || targetView.frame.origin.y > viewOriginY {
            updateView(withOffset: offsetDiff)
            scrollView.contentOffset.y = -contentInsetTop
        }
        previousContentOffsetY = scrollView.contentOffset.y
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startDragging()
        previousContentOffsetY = scrollView.contentOffset.y
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        finishDragging(withVelocity: velocity)
        previousContentOffsetY = 0.0
    }
}

extension SwipeToDismissController: UITableViewDelegate, UICollectionViewDelegate {}
