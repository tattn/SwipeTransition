//
//  BackSwipeable.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

public protocol BackSwipeable: class {
    var swipeBack: BackSwipeController? { get set }
}

public extension BackSwipeable {
    public var swipeBack: BackSwipeController? {
        get {
            return objc_getAssociatedObject(self, &AssocKey.swipeBack) as? BackSwipeController
        }
        set {
            objc_setAssociatedObject(self, &AssocKey.swipeBack, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension UINavigationController {
    public var swipeBack: BackSwipeController? {
        get {
            return objc_getAssociatedObject(self, &AssocKey.swipeBack) as? BackSwipeController
        }
        set {
            objc_setAssociatedObject(self, &AssocKey.swipeBack, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
