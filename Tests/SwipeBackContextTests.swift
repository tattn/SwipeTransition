//
//  SwipeBackContextTests.swift
//  SwipeTransitionTests
//
//  Created by Tatsuya Tanaka on 20171230.
//  Copyright © 2017年 tattn. All rights reserved.
//

import XCTest
@testable import SwipeTransition

class SwipeBackContextTestsTests: XCTestCase {

    private var context: SwipeBackContext!
    private var viewController: UIViewController!
    private var navigationController: UINavigationController!
    private var panGestureRecognizer: TestablePanGestureRecognizer!

    override func setUp() {
        super.setUp()
        viewController = UIViewController()
        navigationController = UINavigationController(rootViewController: UIViewController())
        panGestureRecognizer = TestablePanGestureRecognizer()
        context = SwipeBackContext(navigationController: navigationController)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testAllowsTransitionStart() {
        XCTAssertFalse(context.allowsTransitionStart)
        navigationController.pushViewController(viewController, animated: false)
        XCTAssertTrue(context.allowsTransitionStart)
        context.isEnabled = false
        XCTAssertFalse(context.allowsTransitionStart)
        context.isEnabled = true
        XCTAssertTrue(context.allowsTransitionStart)
        context.animating = true
        XCTAssertFalse(context.allowsTransitionStart)
        context.animating = false
        XCTAssertTrue(context.allowsTransitionStart)
    }
    
    func testStartTransition() {
        navigationController.pushViewController(viewController, animated: false)
        XCTAssertNil(context.interactiveTransition)
        context.startTransition()
        XCTAssertNotNil(context.interactiveTransition)
    }

    func testUpdateTransition() {
        navigationController.pushViewController(viewController, animated: false)
        context.startTransition()
        XCTAssertTrue(context.interactiveTransition?.percentComplete == 0)
        panGestureRecognizer.perfomTouch(location: nil, translation: CGPoint(x: 50, y: 0), state: .changed)
        context.updateTransition(recognizer: panGestureRecognizer)
        // XCTAssertTrue(context.interactiveTransition?.percentComplete != 0) // 🤔
    }

    func testFinishTransition() {
        navigationController.pushViewController(viewController, animated: false)
        context.startTransition()
        context.animating = true
        XCTAssertNotNil(context.interactiveTransition)
        context.finishTransition()
        XCTAssertNil(context.interactiveTransition)
        XCTAssertTrue(context.animating)
    }

    func testCancelTransition() {
        navigationController.pushViewController(viewController, animated: false)
        context.startTransition()
        context.animating = true
        XCTAssertNotNil(context.interactiveTransition)
        context.cancelTransition()
        XCTAssertNil(context.interactiveTransition)
        XCTAssertFalse(context.animating)
    }
}
