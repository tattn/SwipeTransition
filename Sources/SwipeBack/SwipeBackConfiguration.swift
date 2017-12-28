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
    open var transitionDuration: TimeInterval = 0.3
    open var parallaxFactor: CGFloat = 0.3
    open var backViewDimness: CGFloat = 0.1
}
