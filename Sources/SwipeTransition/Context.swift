//
//  Context.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180220.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

protocol TargetHolder {
    associatedtype Target: UIViewController
    var target: Target? { get }

    init(target: Target)
}

extension TargetHolder {
    var targetView: UIView? { return target?.view }
}



protocol ContextType: TransitionHandleable, TargetHolder {
    var isEnabled: Bool { get set }
    var transitioning: Bool { get set }
    var interactiveTransition: InteractiveTransition? { get set }
}

extension ContextType {
    func interactiveTransitionIfNeeded() -> InteractiveTransition? {
        return isEnabled ? interactiveTransition : nil
    }
}



class Context<Target: UIViewController> {
    private(set) weak var target: Target?

    var isEnabled = true
    var transitioning = false

    var interactiveTransition: InteractiveTransition? {
        didSet {
            transitioning = interactiveTransition != nil
        }
    }

    var allowsTransitionStart: Bool {
        return !transitioning && isEnabled
    }

    required init(target: Target) {
        self.target = target
    }
}
