//
//  NSStringCategoryTest.m
//  SocketIMDemoTests
//
//  Created by Mac on 2018/3/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

@import XCTest;

#import "NSString+Category.h"

/**
 NSString+Category类单元测试
 */
@interface NSStringCategoryTest : XCTestCase

@end

@implementation NSStringCategoryTest

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
    //正例判断
    XCTAssertEqual([NSString isBlank:@"hello"], NO);
    
    //反例判断
    XCTAssertEqual([NSString isBlank:nil], YES);
    XCTAssertEqual([NSString isBlank:NULL], YES);
    XCTAssertEqual([NSString isBlank:@""], YES);
    XCTAssertEqual([NSString isBlank:@" "], YES);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
