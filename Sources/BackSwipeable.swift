//
//  BackSwipeable.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

private struct AssocKey {
    private init() {}
    static var backSwipeController: Void?
}

public protocol BackSwipeable: class {
    var backSwipeController: BackSwipeController? { get set }
    var isBackSwipeEnabled: Bool { get set }
}

public extension BackSwipeable {
    public var backSwipeController: BackSwipeController? {
        get {
            return objc_getAssociatedObject(self, &AssocKey.backSwipeController) as? BackSwipeController
        }
        set {
            objc_setAssociatedObject(self, &AssocKey.backSwipeController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UINavigationController {
    public var isBackSwipeEnabled: Bool {
        get {
            return (self as? BackSwipeable)?.backSwipeController != nil
        }
        set {
            if newValue {
                (self as? BackSwipeable)?.backSwipeController = BackSwipeController(navigationController: self)
            } else {
                (self as? BackSwipeable)?.backSwipeController = nil
            }
        }
    }
}
