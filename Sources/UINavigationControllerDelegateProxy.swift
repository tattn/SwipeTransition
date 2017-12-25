//
//  UINavigationControllerDelegateProxy.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171225.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class UINavigationControllerDelegateProxy: DelegateProxy, UINavigationControllerDelegate {
    @nonobjc convenience init(delegates: [UINavigationControllerDelegate]) {
        self.init(__delegates: delegates)
    }
}
