//
//  UINavigationController+AutoSwipeBack.h
//  AutoSwipeBack
//
//  Created by Tatsuya Tanaka on 20171224.
//  Copyright © 2017年 tattn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwipeBackController;

@interface UINavigationController (AutoSwipeBack)
@property(nonatomic, nullable) SwipeBackController* swipeBack;
@end
