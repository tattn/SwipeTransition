//
//  DelegateProxy.h
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STDelegateProxy : NSObject
- (nonnull instancetype)initWithDelegates:(NSArray<id> * __nonnull)delegates NS_REFINED_FOR_SWIFT;
@end
