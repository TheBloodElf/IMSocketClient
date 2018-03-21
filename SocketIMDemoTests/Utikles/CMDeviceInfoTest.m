//
//  CMDeviceInfoTest.m
//  SocketIMDemoTests
//
//  Created by Mac on 2018/3/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

@import XCTest;
@import UIKit;

#import "CMDeviceInfo.h"

/**
 CMDeviceInfo单元测试
 */
@interface CMDeviceInfoTest : XCTestCase {
    
}

@end

@implementation CMDeviceInfoTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //屏幕宽度判断
    CGFloat correctScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat compareScreenWidth = [CMDeviceInfo mainScreenWidth];
    XCTAssertEqual(correctScreenWidth, compareScreenWidth);
    //屏幕高度判断
    CGFloat correctScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat compareScreenHeight = [CMDeviceInfo mainScreenHeight];
    XCTAssertEqual(correctScreenHeight, compareScreenHeight);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
