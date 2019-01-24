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

+ (int)statusBarHeight {
    int height = 20;
    if([self isIphoneX]) {
        height = 44;
    }
    return height;
}

+ (int)navigationBarHeight {
    int height = 44;
    return height;
}

+ (int)tabBarHeight {
    int height = 49;
    if([self isIphoneX]) {
        height = 83;
    }
    return height;
}

+ (BOOL)isIphoneX {
    //iPhone x
    //导航bar {{0, 44}, {x, 44}}
    //tabbar {{0,  x}, {x, 83}}
    //非 iPhone x
    //导航bar {{0, 20}, {x, 44}}
    //tabbar {{0,  x}, {x, 49}}
    return (MAIN_SCREEN_WIDTH == 375.0) && (MAIN_SCREEN_HEIGHT == 812.0);
}

@end
