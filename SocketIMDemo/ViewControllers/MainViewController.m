//
//  MainViewController.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "MainViewController.h"
#import "ChatListController.h"
#import "ChatFriendController.h"
#import "ChatMineController.h"

@interface MainViewController () {
    /**主界面*/
    UITabBarController *_uITabBarController;
}

@end

@implementation MainViewController

#pragma mark -- Init Methods

#pragma mark -- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _uITabBarController = [UITabBarController new];
    _uITabBarController.viewControllers = @[[self listController],[self friendController],[self mineController]];
    [_uITabBarController.view willMoveToSuperview:self.view];
    [self.view addSubview:_uITabBarController.view];
    [_uITabBarController willMoveToParentViewController:self];
    [self addChildViewController:_uITabBarController];
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

- (UIViewController*)listController {
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:[ChatListController new]];
    viewController.tabBarItem.title = @"会话";
    return viewController;
}
- (UIViewController*)friendController {
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:[ChatFriendController new]];
    viewController.tabBarItem.title = @"好友";
    return viewController;
}
- (UIViewController*)mineController {
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:[ChatMineController new]];
    viewController.tabBarItem.title = @"我的";
    return viewController;
}

#pragma mark -- Public Methods

@end
