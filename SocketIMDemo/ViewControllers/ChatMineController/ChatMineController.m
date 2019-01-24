//
//  ChatMineController.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "ChatMineController.h"

@interface ChatMineController () {
    /**用户模型管理器*/
    UserManager *_userManager;
}

@end

@implementation ChatMineController

#pragma mark - Init Method

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initModesAndViews];
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%d)",_userManager.user.nick,_userManager.user.uid];
}

#pragma mark - Class Method

#pragma mark - Override Method

#pragma mark - Function Method

#pragma mark - Private Method

/**
 初始化模型、视图
 */
- (void)initModesAndViews {
    _userManager = [UserManager manager];
}

/**
 添加点击事件
 */
- (void)setViewsClickEvents {
    
}

/**
 设置界面圆角、边框或者其他操作
 */
- (void)setViewsRoundLineOrOtherOperation {
    
}

#pragma mark - Public Method

@end
