//
//  NavigationControllerDelegateProxy.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171225.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

open class NavigationControllerDelegateProxy: STDelegateProxy2, UINavigationControllerDelegate {
    @nonobjc convenience init(delegates: [UINavigationControllerDelegate]) {
        self.init(__delegates: delegates)
    }
}
