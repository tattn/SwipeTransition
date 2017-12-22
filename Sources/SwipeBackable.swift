//
//  SwipeBackable.swift
//  SwipeBackable
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

private struct AssocKey {
    private init() {}
    static var swipeBackController: Void?
}

public protocol SwipeBackable: class {
    var swipeBackController: SwipeBackController? { get set }
    var isSwipeBackEnabled: Bool { get set }
}

public extension SwipeBackable {
    public var swipeBackController: SwipeBackController? {
        get {
            return objc_getAssociatedObject(self, &AssocKey.swipeBackController) as? SwipeBackController
        }
        set {
            objc_setAssociatedObject(self, &AssocKey.swipeBackController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UINavigationController {
    public var isSwipeBackEnabled: Bool {
        get {
            return (self as? SwipeBackable)?.swipeBackController != nil
        }
        set {
            if newValue {
                (self as? SwipeBackable)?.swipeBackController = SwipeBackController(navigationController: self)
            } else {
                (self as? SwipeBackable)?.swipeBackController = nil
            }
        }
    }
}
