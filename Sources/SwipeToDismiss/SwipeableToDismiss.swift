//
//  SwipeableToDismiss.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171223.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

private struct AssocKey {
    private init() {}
    static var swipeToDismiss: Void?
}

public protocol SwipeableToDismiss: class {
    var swipeToDismiss: SwipeToDismissController? { get set }
}

public extension SwipeableToDismiss where Self: UIViewController {
    public var swipeToDismiss: SwipeToDismissController? {
        get {
            return objc_getAssociatedObject(self, &AssocKey.swipeToDismiss) as? SwipeToDismissController
        }
        set {
            objc_setAssociatedObject(self, &AssocKey.swipeToDismiss, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func configureSwipeToDismiss(scrollView: UIScrollView? = nil, navigationBar: UIView? = nil) {
        if let scrollView = scrollView {
            swipeToDismiss = SwipeToDismissController(scrollView: scrollView)
        } else {
            swipeToDismiss = SwipeToDismissController(view: view)
        }
        swipeToDismiss?.navigationBar = navigationBar
    }
}
