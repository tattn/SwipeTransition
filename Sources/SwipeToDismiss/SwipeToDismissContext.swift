//
//  SwipeToDismissContext.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171228.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class SwipeToDismissContext {
    weak var viewControllerToDismiss: UIViewController?
    private var target: UIViewController? {
        return viewControllerToDismiss?.navigationController ?? viewControllerToDismiss
    }

    // Delegate Proxies (strong reference)
    var proxies: [ScrollViewDelegateProxy] = []

    var isEnabled = true
    var dragging = false

    private var viewPositionY: CGFloat = 0.0
    private var previousContentOffsetY: CGFloat = 0.0

    private let viewOriginY: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.statusBarFrame.height
        } else {
            return 0
        }
    }()

    init(viewController: UIViewController) {
        viewControllerToDismiss = viewController
    }

    func startDragging(withScrollViewOffsetY scrollViewOffsetY: CGFloat = 0) {
        guard let view = target?.view, isEnabled else { return }
        view.layer.removeAllAnimations()

        // [Workaround] I'd like to know if there is a better way.
        // For the first time, when the view.frame.origin.y is 0, the top of the screen is the origin,
        // but when scrolling, the bottom of the status bar becomes the origin.
        // So adjust the origin in advance to scroll smoothly.
        view.frame.origin.y = viewOriginY + 0.01
        view.layoutIfNeeded()
        view.frame.origin.y = viewOriginY

        dragging = true
        viewPositionY = viewOriginY
        previousContentOffsetY = scrollViewOffsetY
    }

    func updateDragging(withOffset offset: CGFloat) {
        guard let view = target?.view else { return }
        viewPositionY += offset
        view.frame.origin.y = max(viewOriginY, viewPositionY)
    }

    func updateDragging(with scrollView: UIScrollView) {
        guard dragging, let targetView = target?.view else { return }
        let offsetDiff = previousContentOffsetY - scrollView.contentOffset.y
        let contentInsetTop = scrollView.contentInset.top
        if scrollView.contentOffset.y < -contentInsetTop || targetView.frame.origin.y > viewOriginY {
            updateDragging(withOffset: offsetDiff)
            scrollView.contentOffset.y = -contentInsetTop
        }
        previousContentOffsetY = scrollView.contentOffset.y
    }

    func finishDragging(withVelocityY velocityY: CGFloat) {
        guard let view = target?.view, isEnabled else { return }
        let originY = view.frame.origin.y
        let heightToDismiss = view.frame.height * SwipeToDismissConfiguration.shared.dismissHeightRatio
        if originY > heightToDismiss || originY > 0 && velocityY < 0 {
            dismiss()
        } else if originY != viewOriginY {
            UIView.perform(.delete, on: [], options: [.allowUserInteraction], animations: { [weak self] in
                view.frame.origin.y = self?.viewOriginY ?? 0
            }, completion: { _ in
            })
        }

        dragging = false
        viewPositionY = viewOriginY
        previousContentOffsetY = 0.0
    }

    func dismiss() {
        target?.dismiss(animated: true)
    }
}
