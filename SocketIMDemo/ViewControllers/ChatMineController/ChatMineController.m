//
//  ChatMineController.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "ChatMineController.h"

//Views
#import "ChatMineView.h"

@interface ChatMineController () {
    /**用户数据管理器*/
    UserManager *_userManager;
    /**聊天模块*/
    UserIMSocket *_userIMSocket;
    
}

@end

@implementation ChatMineController

#pragma mark -- Init Methods

- (instancetype)init {
    if(self = [super init]) {
        self.navigationItem.title = @"我";
        _userManager = [UserManager manager];
        _userIMSocket = [UserIMSocket socket];
    }
    return self;
}

#pragma mark -- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建视图部分
    ChatMineView *chatMineView = [[ChatMineView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    [self.view addSubview:chatMineView];
    //用当前登录用户信息配置界面
    [self configViewsUseUserInfo];
    //设置导航按钮
    [self setNavigationRightBarButtonItem];
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

/**
 用当前登录用户信息配置界面
 */
- (void)configViewsUseUserInfo {
    //用户头像
    UIImageView *imageView = [self.view viewWithTag:USER_AVATER_IMAGEVIEW_TAG];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_userManager.user.avatar] placeholderImage:[UIImage imageNamed:@"default_image_icon"]];
    
    //用户名称
    UILabel *label = [self.view viewWithTag:USER_NAME_LABEL_TAG];
    label.text = _userManager.user.nick;
}

/**
 设置右边导航
 */
- (void)setNavigationRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(navigationRightItemClick:)];
}

#pragma mark -- Public Methods

#pragma mark -- Action Methods

- (void)navigationRightItemClick:(UIBarButtonItem*)item {
    //退出聊天服务器
    [_userIMSocket disconnect];
}

@end
