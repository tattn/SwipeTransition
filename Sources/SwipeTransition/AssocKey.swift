//
//  AssocKey.swift
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

import Foundation

struct AssocKey {
    private init() {}
    static var swipeBack: Void?
    static var swipeToDismiss: Void?
}

// swiftlint:disable type_name
@available(swift 256)
@objcMembers
public class __AssocKey: NSObject {
    public static var swipeBack: UnsafeRawPointer {
        return pointer(&AssocKey.swipeBack)
    }
    public static var swipeToDismiss: UnsafeRawPointer {
        return pointer(&AssocKey.swipeToDismiss)
    }

    private static func pointer(_ ptr: UnsafeRawPointer) -> UnsafeRawPointer {
        return ptr
    }
}
