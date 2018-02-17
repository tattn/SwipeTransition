//
//  SwipeBackConfiguration.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

open class SwipeBackConfiguration {
    public static var shared = SwipeBackConfiguration()
    public init() {}
    /// Duration of the dismiss animation
    open var transitionDuration: TimeInterval = 0.3

    /// Factor of the background view parallax
    open var parallaxFactor: CGFloat = 0.3

    /// Dimness of the background view
    open var backViewDimness: CGFloat = 0.1
}
