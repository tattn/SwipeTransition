//
//  DelegateProxy.h
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

#ifndef SWIPETRANSITION_DELEGATEPROXY
#define SWIPETRANSITION_DELEGATEPROXY

#import <Foundation/Foundation.h>

// Duplicate the class for Swift's bug close to this
// https://bugs.swift.org/browse/SR-6023

@interface STDelegateProxy : NSObject
- (nonnull instancetype)initWithDelegates:(NSArray<id> * __nonnull)delegates NS_REFINED_FOR_SWIFT;
@end

@interface STDelegateProxy2 : NSObject
- (nonnull instancetype)initWithDelegates:(NSArray<id> * __nonnull)delegates NS_REFINED_FOR_SWIFT;
@end

#endif

