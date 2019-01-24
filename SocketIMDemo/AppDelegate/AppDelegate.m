//
//  AppDelegate.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "AppDelegate.h"

//ViewControlles
#import "MainViewController.h"

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置全局样式
    [AppCustoms customs];
    
    //设置当前登录用户信息 写死，没登录操作
    User *currUser = [[UserManager manager] allUsers][0];
    [[UserManager manager] updateCurrUser:currUser];
    
    //设置当前聊天用户信息 这里的信息是根据当前登录用户信息来的 写死，没登录操作
    IMChater *chater = [IMChater new];
    chater.imid = currUser.uid;
    chater.nick = currUser.nick;
    chater.avatar = currUser.avatar;
    [[IMUserManager manager] updateCurrChater:chater];
    //连接聊天服务器
    [[IMUserSocket socket] connect];
    
    //初始化rootVc
    MainViewController *mainViewController = [MainViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    
    //键盘遮挡问题解决方案
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

#pragma mark -- Private Methods

@end
