//
//  DelegateProxyswift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171226.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

// Wrap the delegate proxy to avoid the same bug
// https://bugs.swift.org/browse/SR-6023

class DelegateProxy<T>: STDelegateProxy {
    @nonobjc convenience init(delegates: [T]) {
        self.init(__delegates: delegates)
    }
}
