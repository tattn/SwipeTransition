//
//  UINavigationController+AutoSwipeBack.m
//  AutoSwipeBack
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <SwipeTransition/SwipeTransition-Swift.h>
#import "UINavigationController+AutoSwipeBack.h"

@implementation UINavigationController (AutoSwipeBack)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(autoswipeback_viewDidLoad);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL isAdded = class_addMethod(class,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod));

        if (isAdded) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)autoswipeback_viewDidLoad
{
    UIView* _ __unused = self.view;
    self.swipeBack = [[SwipeBackController alloc] initWithNavigationController:self];
    [self autoswipeback_viewDidLoad];
}

- (void)setSwipeBack:(SwipeBackController*)swipeBack
{
    objc_setAssociatedObject(self, __AssocKey.swipeBack, swipeBack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SwipeBackController*)swipeBack
{
    return objc_getAssociatedObject(self, __AssocKey.swipeBack);
}
@end
