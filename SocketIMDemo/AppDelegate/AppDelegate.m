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

//Managers
#import "UserManager.h"
#import "UserIMSocket.h"

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //伪造三个用户体系中的用户User对象
    UserManager *userManager = [UserManager manager];
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
    [userManager updateUsers:[@[user1,user2,user3] mutableCopy]];
    
    //设置当前登录用户信息
    User *currUser = [User new];
    currUser.uid = 10002;
    currUser.nick = @"用户10002";
    currUser.avatar = @"http://files-t.59bang.com//@/30149/0/avatar/2017122720171227185301_1553.jpg";
    [userManager updateCurrUser:currUser];
    
    //连接聊天服务器
    [[UserIMSocket socket] connect];
    
    //初始化rootVc
    MainViewController *mainViewController = [MainViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = mainViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

@end
