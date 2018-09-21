//
//  ObjectiveCSupportTests.m
//  SwipeTransitionTests
//
//  Created by Tatsuya Tanaka on 20180921.
//  Copyright © 2018年 tattn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SwipeTransition/SwipeTransition.h>
#import <AutoSwipeToDismiss/AutoSwipeToDismiss.h>

@interface ObjectiveCSupportTests : XCTestCase

@end

@implementation ObjectiveCSupportTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testAccessEnabledProperty {
    UIViewController *vc = [UIViewController new];
    vc.swipeToDismiss.isEnabled = NO;
    XCTAssertFalse(vc.swipeToDismiss.isEnabled);
}

@end
