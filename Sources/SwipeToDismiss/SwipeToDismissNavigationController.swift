//
//  SwipeToDismissNavigationController.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171223.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

open class SwipeToDismissNavigationController: UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        swipeBack = SwipeBackController(navigationController: self)
        swipeToDismiss = SwipeToDismissController(viewController: self)
        modalPresentationStyle = .overFullScreen
    }
}
