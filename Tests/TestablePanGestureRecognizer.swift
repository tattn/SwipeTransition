//
//  TestablePanGestureRecognizer.swift
//  SwipeTransitionTests
//
//  Created by Tatsuya Tanaka on 20171230.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

class TestablePanGestureRecognizer: UIPanGestureRecognizer {
    let testTarget: AnyObject?
    let testAction: Selector?

    var testState: UIGestureRecognizer.State?
    var testLocation: CGPoint?
    var testTranslation: CGPoint?

    override init(target: Any?, action: Selector?) {
        testTarget = target as AnyObject
        testAction = action
        super.init(target: target, action: action)
    }

    func perfomTouch(location: CGPoint?, translation: CGPoint?, state: UIGestureRecognizer.State) {
        testLocation = location
        testTranslation = translation
        testState = state
        if let testAction = testAction {
            (testTarget as AnyObject).perform(testAction, on: .current, with: self, waitUntilDone: true)
        }
    }

    override func location(in view: UIView?) -> CGPoint {
        if let testLocation = testLocation {
            return testLocation
        }
        return super.location(in: view)
    }

    override func translation(in view: UIView?) -> CGPoint {
        if let testTranslation = testTranslation {
            return testTranslation
        }
        return super.translation(in: view)
    }

    override var state: UIGestureRecognizer.State {
        get {
            if let testState = testState {
                return testState
            }
            return super.state
        }
        set {
            super.state = newValue
        }
    }
}
