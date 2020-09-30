//
//  SwipeToDismissConfiguration.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171223.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation
import CoreGraphics.CGBase

open class SwipeToDismissConfiguration {
    public static var shared = SwipeToDismissConfiguration()
    public init() {}

    /// Threshold of the height to dismiss
    open var dismissHeightRatio: CGFloat = 0.3 {
        didSet {
            assert(0 < dismissHeightRatio && dismissHeightRatio < 1, "dismissHeightRatio must be in the range of 0.0 to 1.0")
        }
    }

    /// Threshold of the finger speed to dismiss [pt/s]
    open var dismissSwipeSpeed: CGFloat? = 1600

    /// Duration of the dismiss animation [s]
    open var transitionDuration: TimeInterval = 0.3

    /// Wait time until the dismiss animation [s]
    open var animationWaitTime: TimeInterval = 0.01
}
