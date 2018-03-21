//
//  UIColorFlatUITest.m
//  SocketIMDemoTests
//
//  Created by Mac on 2018/3/21.
//  Copyright © 2018年 Mac. All rights reserved.
//

@import XCTest;

#import "UIColor+FlatUI.h"

/**
 UIColor+FlatUI单元测试
 */
@interface UIColorFlatUITest : XCTestCase

@end

@implementation UIColorFlatUITest

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
    XCTAssert([UIColor colorNamed:@"111"] == nil);
    XCTAssert([UIColor colorNamed:@"#111"] == nil);
    XCTAssert([UIColor colorNamed:@"111111"] == nil);
    XCTAssert([UIColor colorNamed:@"#111111"] == nil);
    
    //反例判断
    XCTAssertEqual([UIColor colorNamed:@""], nil);
    XCTAssertEqual([UIColor colorNamed:@"1"], nil);
    XCTAssertEqual([UIColor colorNamed:@"11"], nil);
    XCTAssertEqual([UIColor colorNamed:@"1111"], nil);
    XCTAssertEqual([UIColor colorNamed:@"11111"], nil);
    XCTAssertEqual([UIColor colorNamed:@"#"], nil);
    XCTAssertEqual([UIColor colorNamed:@"#1"], nil);
    XCTAssertEqual([UIColor colorNamed:@"#11"], nil);
    XCTAssertEqual([UIColor colorNamed:@"#1111"], nil);
    XCTAssertEqual([UIColor colorNamed:@"#11111"], nil);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
