//
//  OneFingerPanGestureRecognizer.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180124.
//  Copyright © 2018年 tattn. All rights reserved.
//

import Foundation

class OneFingerPanGestureRecognizer: UIPanGestureRecognizer {
    convenience init() {
        self.init(target: nil, action: nil)
    }

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        maximumNumberOfTouches = 1
    }
}
