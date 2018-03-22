//
//  CMDeviceInfo.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#ifndef MAIN_SCREEN_WIDTH
#define MAIN_SCREEN_WIDTH   [CMDeviceInfo mainScreenWidth]
#endif

#ifndef MAIN_SCREEN_HEIGHT
#define MAIN_SCREEN_HEIGHT  [CMDeviceInfo mainScreenHeight]
#endif

#ifndef MAIN_SCREEN_WIDTH_SCALE
#define MAIN_SCREEN_WIDTH_SCALE   (MAIN_SCREEN_WIDTH / 375.0)
#endif

#ifndef MAIN_SCREEN_HEIGHT_SCALE
#define MAIN_SCREEN_HEIGHT_SCALE  (MAIN_SCREEN_HEIGHT / 667.0)
#endif

/**
 当前设备信息
 */
@interface CMDeviceInfo : NSObject

/**
 获取屏幕宽度

 @return 屏幕宽度
 */
+ (CGFloat)mainScreenWidth;

/**
 获取屏幕高度
 
 @return 屏幕高度
 */
+ (CGFloat)mainScreenHeight;

@end
