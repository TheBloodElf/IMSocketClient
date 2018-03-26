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
    //伪造三个用户体系中的用户User对象
    User *user1 = [User new];
    user1.uid = 10001;
    user1.nick = @"用户10001";
    user1.avatar = @"http://files-t.59bang.com//@/30152/0/avatar/2017122820171228130710_2280.jpg";
    User *user2 = [User new];
    user2.uid = 10002;
    user2.nick = @"用户10002";
    user2.avatar = @"http://files-t.59bang.com//@/30149/0/avatar/2017122720171227185301_1553.jpg";
    User *user3 = [User new];
    user3.uid = 10003;
    user3.nick = @"用户10003";
    user3.avatar = @"http://files-t.59bang.com//@/30152/0/avatar/2017122820171228130710_2280.jpg";
    [[UserManager manager] updateUsers:[@[user1,user2,user3] mutableCopy]];
    
    //设置当前登录用户信息 写死，没登录操作
    User *currUser = [User new];
    currUser.uid = 10002;
    currUser.nick = @"用户10002";
    currUser.avatar = @"http://files-t.59bang.com//@/30149/0/avatar/2017122720171227185301_1553.jpg";
    [[UserManager manager] updateCurrUser:currUser];
    
    //设置当前聊天用户信息 这里的信息是根据当前登录用户信息来的 写死，没登录操作
    IMUserManager *iMUserManager = [IMUserManager manager];
    Chater *chater = [Chater new];
    chater.imid = currUser.uid;
    chater.nick = currUser.nick;
    chater.avatar = currUser.avatar;
    [iMUserManager updateCurrChater:chater];
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
