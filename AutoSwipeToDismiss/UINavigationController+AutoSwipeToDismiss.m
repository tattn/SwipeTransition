//
//  UINavigationController+AutoSwipeToDismiss.m
//  AutoSwipeToDismiss
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <AutoSwipeToDismiss/AutoSwipeToDismiss-Swift.h>
#import "UINavigationController+AutoSwipeToDismiss.h"

@implementation UINavigationController (AutoSwipeToDismiss)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(autoswipetodismiss_viewDidLoad);

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

- (void)autoswipetodismiss_viewDidLoad
{
    [self autoswipetodismiss_viewDidLoad];

    self.swipeToDismiss = [[SwipeToDismissController alloc] initWithView:self.view];

}

- (void)setSwipeToDismiss:(SwipeToDismissController*)swipeToDismiss
{
    objc_setAssociatedObject(self, __AssocKey.swipeToDismiss, swipeToDismiss, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SwipeToDismissController*)swipeToDismiss
{
    return objc_getAssociatedObject(self, __AssocKey.swipeToDismiss);
}
@end
