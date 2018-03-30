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

//Managers
#import "ChatMineTableViewManager.h"

@interface ChatMineController () {
    /**用户数据管理器*/
    UserManager *_userManager;
    
    /**聊天数据管理器*/
    IMUserManager *_iMUserManager;
    /**聊天模块*/
    IMUserSocket *_iMUserSocket;
    
    /**表格视图管理者*/
    ChatMineTableViewManager *_tableViewManager;
}

@end

@implementation ChatMineController

#pragma mark -- Init Methods

- (instancetype)init {
    if(self = [super init]) {
        _userManager = [UserManager manager];
        _iMUserSocket = [IMUserSocket socket];
        _iMUserManager = [IMUserManager manager];
    }
    return self;
}

#pragma mark -- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@日志记录",_userManager.user.nick];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建视图部分
    ChatMineView *chatMineView = [[ChatMineView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 64 - 49)];
    [self.view addSubview:chatMineView];
    UITableView *tableView = [self.view viewWithTag:LOG_TABLE_VIEW_TAG];
    _tableViewManager = [[ChatMineTableViewManager alloc] initWithLogs:[_iMUserManager allClientLogs] tableView:tableView];
    tableView.delegate = _tableViewManager;
    tableView.dataSource = _tableViewManager;
    //实时监听日志表变化
    __weak typeof(self) weakSelf = self;
    [_iMUserManager addClientLogChangeListener:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf clientLogChange];
    }];
    //设置导航按钮
    [self setNavigationRightBarButtonItem];
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

- (void)clientLogChange {
    [_tableViewManager updateLogs:[_iMUserManager allClientLogs]];
}

/**
 设置右边导航
 */
- (void)setNavigationRightBarButtonItem {
    
}

#pragma mark -- Public Methods

#pragma mark -- Action Methods

@end
