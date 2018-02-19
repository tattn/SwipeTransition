//
//  OneFingerDirectionalPanGestureRecognizer.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20180124.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

final class OneFingerDirectionalPanGestureRecognizer: UIPanGestureRecognizer {
    enum PanDirection {
        case vertical
        case horizontal
    }

    let direction: PanDirection

    required init(direction: PanDirection, target: Any? = nil, action: Selector? = nil) {
        self.direction = direction
        super.init(target: target, action: action)
        maximumNumberOfTouches = 1
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        if state == .began {
            let vel = velocity(in: view)
            switch direction {
            case .horizontal where fabs(vel.y) > fabs(vel.x):
                state = .cancelled
            case .vertical where fabs(vel.x) > fabs(vel.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}
