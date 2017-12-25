//
//  ScrollViewDelegateProxy.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171223.
//  Copyright © 2017年 tattn. All rights reserved.
//

import UIKit

final class ScrollViewDelegateProxy: STDelegateProxy, UIScrollViewDelegate {
    @nonobjc convenience init(delegates: [UIScrollViewDelegate]) {
        self.init(__delegates: delegates)
    }
}
