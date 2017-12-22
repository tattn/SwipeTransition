//
//  SwipeBackableNavigationController.swift
//  SwipeBackable
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

open class SwipeBackableNavigationController: UINavigationController, SwipeBackable {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.swipeBackController = SwipeBackController(navigationController: self)
    }
}
