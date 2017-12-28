//
//  SwipeBackExtensions.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

public extension UINavigationController {
    public var swipeBack: SwipeBackController? {
        get {
            return objc_getAssociatedObject(self, &AssocKey.swipeBack) as? SwipeBackController
        }
        set {
            objc_setAssociatedObject(self, &AssocKey.swipeBack, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
