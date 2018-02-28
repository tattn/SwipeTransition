//
//  UINavigationController+AutoSwipeToDismiss.m
//  AutoSwipeToDismiss
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <SwipeTransition/SwipeTransition-Swift.h>
#import "UINavigationController+AutoSwipeToDismiss.h"

void AutoSwipeToDismiss_SwizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
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

@implementation UIViewController (AutoSwipeToDismiss)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        AutoSwipeToDismiss_SwizzleInstanceMethod(class, @selector(initWithCoder:), @selector(autoswipetodismiss_initWithCoder:));
        AutoSwipeToDismiss_SwizzleInstanceMethod(class, @selector(init), @selector(autoswipetodismiss_init));
        AutoSwipeToDismiss_SwizzleInstanceMethod(class, @selector(initWithNibName:bundle:), @selector(autoswipetodismiss_initWithNibName:bundle:));
        AutoSwipeToDismiss_SwizzleInstanceMethod(class, @selector(initWithRootViewController:), @selector(autoswipetodismiss_initWithRootViewController:));
        AutoSwipeToDismiss_SwizzleInstanceMethod(class, @selector(viewWillAppear:), @selector(autoswipetodismiss_viewWillAppear:));
    });
}

- (instancetype)autoswipetodismiss_initWithCoder:(nonnull NSCoder *)aCoder
{
    [self autoswipetodismiss_initWithCoder:aCoder];
    [self setupSwipeToDismiss];
    return self;
}

- (instancetype)autoswipetodismiss_init
{
    [self autoswipetodismiss_init];
    [self setupSwipeToDismiss];
    return self;
}

- (instancetype)autoswipetodismiss_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [self autoswipetodismiss_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setupSwipeToDismiss];
    return self;
}

- (instancetype)autoswipetodismiss_initWithRootViewController:(nonnull UIViewController*)viewController
{
    [self autoswipetodismiss_initWithRootViewController:viewController];
    [self setupSwipeToDismiss];
    return self;
}

- (void)autoswipetodismiss_viewWillAppear:(BOOL)animated
{
    [self autoswipetodismiss_viewWillAppear:animated];

    if ([self isFirstViewWillAppear]) {
        [self setIsFirstViewWillAppear:NO];
        UIViewController* target = self.navigationController == nil ? self : self.navigationController;
        if (target.presentedViewController
            || target.presentingViewController.presentedViewController == target
            || [target.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]]) {
            [self.swipeToDismiss addSwipeGesture];
        }
    }
}

- (void)setupSwipeToDismiss {
    if (self.swipeToDismiss
        || [self isKindOfClass:[UINavigationController class]]
        || [self isKindOfClass:[UIAlertController class]]
        || [self isKindOfClass:[UISearchController class]]) {
        return;
    }
    @try {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.swipeToDismiss = [[SwipeToDismissController alloc] initWithViewController:self];
    } @catch (NSException *exception) {} // for UISearchController and so on...
}

- (void)setSwipeToDismiss:(nullable SwipeToDismissController*)swipeToDismiss
{
    objc_setAssociatedObject(self, __AssocKey.swipeToDismiss, swipeToDismiss, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable SwipeToDismissController*)swipeToDismiss
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
