//
//  BackSwipeableNavigationController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

open class BackSwipeableNavigationController: UINavigationController, BackSwipeable {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.backSwipeController = BackSwipeController(navigationController: self)
    }
}
