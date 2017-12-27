//
//  DelegateProxyswift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171226.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

class DelegateProxy<T>: STDelegateProxy {
    @nonobjc convenience init(delegates: [T]) {
        self.init(__delegates: delegates)
    }
}

final class ScrollViewDelegateProxy: DelegateProxy<UIScrollViewDelegate>, UIScrollViewDelegate {}
final class NavigationControllerDelegateProxy: DelegateProxy<UINavigationControllerDelegate>, UINavigationControllerDelegate {}
