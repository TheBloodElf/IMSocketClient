//
//  CMDeviceInfo.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

/**屏幕宽度*/
#ifndef MAIN_SCREEN_WIDTH
#define MAIN_SCREEN_WIDTH   [CMDeviceInfo mainScreenWidth]
#endif

/**屏幕高度*/
#ifndef MAIN_SCREEN_HEIGHT
#define MAIN_SCREEN_HEIGHT  [CMDeviceInfo mainScreenHeight]
#endif

/**宽度相对于6s的缩放比例*/
#ifndef MAIN_SCREEN_WIDTH_SCALE
#define MAIN_SCREEN_WIDTH_SCALE   (MAIN_SCREEN_WIDTH / 375.0)
#endif

/**高度相对于6s的缩放比例*/
#ifndef MAIN_SCREEN_HEIGHT_SCALE
#define MAIN_SCREEN_HEIGHT_SCALE  (MAIN_SCREEN_HEIGHT / 667.0)
#endif

/**导航栏高度*/
#ifndef NAVIGATION_BAR_HEIGHT
#define NAVIGATION_BAR_HEIGHT  [CMDeviceInfo navigationBarHeight]
#endif

/**状态栏高度*/
#ifndef STATUS_BAR_HEIGHT
#define STATUS_BAR_HEIGHT  [CMDeviceInfo statusBarHeight]
#endif

/**tabbar栏高度*/
#ifndef TAB_BAR_HEIGHT
#define TAB_BAR_HEIGHT  [CMDeviceInfo tabBarHeight]
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

/**
 statusBar高度

 @return statusBar高度
 */
+ (int)statusBarHeight;

/**
 navigationBar高度

 @return navigationBar高度
 */
+ (int)navigationBarHeight;

/**
 tabBar高度

 @return tabBar高度
 */
+ (int)tabBarHeight;

@end
