//
//  SwipeToDismissTests.swift
//  SwipeTransitionTests
//
//  Created by Tatsuya Tanaka on 20180228.
//  Copyright © 2018年 tattn. All rights reserved.
//

import XCTest
import WebKit

class SwipeToDismissTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testScrollViewOfWebView() {
        XCTAssertTrue(UIWebView().subviews.contains { $0 is UIScrollView })
        XCTAssertTrue(WKWebView().subviews.contains { $0 is UIScrollView })
    }

}
