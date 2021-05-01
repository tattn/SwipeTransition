//
//  DelegateProxy.m
//  SwipeTransition
//
//  Created by Tatsuya Tanaka on 20171222.
//  Copyright © 2017年 tattn. All rights reserved.
//

#import "DelegateProxy.h"

@interface STDelegateProxy ()
@property (nonnull, nonatomic, strong) NSHashTable<NSObject *> *delegates;
@end

@implementation STDelegateProxy

- (instancetype)initWithDelegates:(NSArray<id> *)delegates {
    self = [super init];
    if (self != nil) {
        self.delegates = [NSHashTable weakObjectsHashTable];
        for (id delegate in delegates) {
            if (![delegate isKindOfClass:[NSObject class]] || [delegate isKindOfClass:[NSNull class]]) {
                continue;
            }
            [self.delegates addObject:delegate];
        }
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    for (NSObject *delegate in self.delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return [delegate methodSignatureForSelector:aSelector];
        }
    }
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (NSObject *delegate in self.delegates) {
        if ([delegate respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:delegate];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    for (NSObject *delegate in self.delegates) {
        if ([delegate respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

@end
