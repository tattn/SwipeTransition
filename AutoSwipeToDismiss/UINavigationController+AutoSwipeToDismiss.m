//
//  UINavigationController+AutoSwipeToDismiss.m
//  AutoSwipeToDismiss
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <SwipeTransition/SwipeTransition.h>
#import "UINavigationController+AutoSwipeToDismiss.h"

@implementation UINavigationController (AutoSwipeToDismiss)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        {
            SEL originalSelector = @selector(initWithCoder:);
            SEL swizzledSelector = @selector(autoswipetodismiss_initWithCoder:);

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
        }

        {
            SEL originalSelector = @selector(init);
            SEL swizzledSelector = @selector(autoswipetodismiss_init);

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
        }

        {
            SEL originalSelector = @selector(initWithRootViewController:);
            SEL swizzledSelector = @selector(autoswipetodismiss_initWithRootViewController:);

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
        }

//        {
//            SEL originalSelector = @selector(viewDidLoad);
//            SEL swizzledSelector = @selector(autoswipetodismiss_viewDidLoad);
//
//            Method originalMethod = class_getInstanceMethod(class, originalSelector);
//            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//            BOOL isAdded = class_addMethod(class,
//                                           originalSelector,
//                                           method_getImplementation(swizzledMethod),
//                                           method_getTypeEncoding(swizzledMethod));
//
//            if (isAdded) {
//                class_replaceMethod(class,
//                                    swizzledSelector,
//                                    method_getImplementation(originalMethod),
//                                    method_getTypeEncoding(originalMethod));
//            } else {
//                method_exchangeImplementations(originalMethod, swizzledMethod);
//            }
//        }

        {
            SEL originalSelector = @selector(viewWillAppear:);
            SEL swizzledSelector = @selector(autoswipetodismiss_viewWillAppear:);

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
        }
    });
}

- (instancetype)autoswipetodismiss_initWithCoder:(nonnull NSCoder *)aCoder
{
    [self autoswipetodismiss_initWithCoder:aCoder];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return self;
}

- (instancetype)autoswipetodismiss_init
{
    [self autoswipetodismiss_init];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return self;
}

- (instancetype)autoswipetodismiss_initWithRootViewController:(nonnull UIViewController*)viewController
{
    [self autoswipetodismiss_initWithRootViewController:viewController];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return self;
}

- (void)autoswipetodismiss_viewDidLoad
{
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self autoswipetodismiss_viewDidLoad];
}

- (void)autoswipetodismiss_viewWillAppear:(BOOL)animated
{
    [self autoswipetodismiss_viewWillAppear:animated];

    if ([self isFirstViewWillAppear]) {
        [self setIsFirstViewWillAppear:NO];
        if (self.presentedViewController
            || self.presentingViewController.presentedViewController == self
            || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]]) {
            self.swipeToDismiss = [[SwipeToDismissController alloc] initWithView:self.view];
        }
    }

}

- (void)setSwipeToDismiss:(SwipeToDismissController*)swipeToDismiss
{
    objc_setAssociatedObject(self, __AssocKey.swipeToDismiss, swipeToDismiss, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SwipeToDismissController*)swipeToDismiss
{
    return objc_getAssociatedObject(self, __AssocKey.swipeToDismiss);
}

- (void)setIsFirstViewWillAppear:(BOOL)isFirstViewWillAppear
{
    objc_setAssociatedObject(self, @selector(isFirstViewWillAppear), [NSNumber numberWithBool:isFirstViewWillAppear], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFirstViewWillAppear
{
    return objc_getAssociatedObject(self, @selector(isFirstViewWillAppear)) == nil;
}

@end
