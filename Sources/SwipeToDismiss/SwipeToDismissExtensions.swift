//
//  SwipeToDismissExtensions.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171223.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

public extension UIViewController {
    public var swipeToDismiss: SwipeToDismissController? {
        get {
            return objc_getAssociatedObject(self, &AssocKey.swipeToDismiss) as? SwipeToDismissController
        }
        set {
            objc_setAssociatedObject(self, &AssocKey.swipeToDismiss, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
