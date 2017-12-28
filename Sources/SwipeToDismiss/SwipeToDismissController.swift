//
//  SwipeToDismissController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171223.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

@objcMembers
public class SwipeToDismissController: NSObject {

    public var isEnabled: Bool {
        get { return context.isEnabled }
        set { context.isEnabled = newValue }
    }

    private let context: SwipeToDismissContext

    private var panGestures: [UIPanGestureRecognizer] = []

    public required init?(viewController: UIViewController) {
        context = SwipeToDismissContext(viewController: viewController)
        super.init()
        viewController.navigationController.map { addGesture(to: $0.navigationBar) }
        addGesture(to: viewController.view)
    }

    deinit {
        panGestures.forEach { $0.view?.removeGestureRecognizer($0) }
    }

    public func setScrollViews(_ scrollViews: [UIScrollView]) {
        context.proxies = scrollViews
            .map { ScrollViewDelegateProxy(delegates: [self] + ($0.delegate.map { [$0] } ?? [])) }
        zip(scrollViews, context.proxies).forEach { $0.delegate = $1 }
    }

    private func addGesture(to view: UIView) {
        for gesture in panGestures where gesture.view == view {
            view.removeGestureRecognizer(gesture)
        }
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(gesture)
        panGestures.append(gesture)
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            context.startDragging()
        case .changed:
            let offsetY = gesture.translation(in: gesture.view).y
            context.updateDragging(withOffset: offsetY)
            gesture.setTranslation(.zero, in: gesture.view)
        case .ended:
            context.finishDragging(withVelocityY: 0)
        default:
            break
        }
    }
}

extension SwipeToDismissController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        context.updateDragging(with: scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        context.startDragging(withScrollViewOffsetY: scrollView.contentOffset.y)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        context.finishDragging(withVelocityY: velocity.y)
    }
}

extension SwipeToDismissController: UITableViewDelegate, UICollectionViewDelegate {}
