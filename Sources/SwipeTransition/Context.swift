//
//  Context.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180220.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

class Context<Target: UIViewController> {
    private(set) weak var target: Target?
    var targetView: UIView? { return target?.view }

    var interactiveTransition: InteractiveTransition?

    var isEnabled = true

    init(target: Target) {
        self.target = target
    }

    func interactiveTransitionIfNeeded() -> InteractiveTransition? {
        return isEnabled ? interactiveTransition : nil
    }
}
