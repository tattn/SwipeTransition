//
//  InteractiveTransition.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class InteractiveTransition: UIPercentDrivenInteractiveTransition {
    override init() {
        super.init()
        completionCurve = .linear
    }

    func update(value: CGFloat, maxValue: CGFloat) {
        let percentComplete = value > 0 ? value / maxValue : 0 // .linear
        update(percentComplete)
    }
}
