//
//  CMDeviceInfo.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "CMDeviceInfo.h"
#import "sys/utsname.h"
#import "sys/utsname.h"

@implementation CMDeviceInfo

#pragma mark - Public methods

+ (CGFloat)mainScreenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)mainScreenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
