//
//  ChatFriendController.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "ChatFriendController.h"

#import "ChatFriendView.h"

#import "UserManager.h"
#import "ChatFriendTableViewManager.h"

#import "PrivateChatController.h"

@interface ChatFriendController ()<UserDidSelectDelegate> {
    /**用户数据管理器*/
    UserManager *_userManager;
    /**表格视图管理器*/
    ChatFriendTableViewManager *_tableViewManager;
}

@end

@implementation ChatFriendController

#pragma mark -- Init Methods

- (instancetype)init {
    if(self = [super init]) {
        self.navigationItem.title = @"好友";
        _userManager = [UserManager manager];
    }
    return self;
}

#pragma mark -- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建视图部分
    ChatFriendView *chatFriendView = [[ChatFriendView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 64)];
    [self.view addSubview:chatFriendView];
    //设置表格视图数据源
    UITableView *tableView = [self.view viewWithTag:FRIEND_TABLEVIEW_TAG];
    _tableViewManager = [[ChatFriendTableViewManager alloc] initWithUsers:[_userManager allUsers] tableView:tableView];
    _tableViewManager.userSelectDelegate = self;
}

#pragma mark -- Class Private Methods

#pragma mark -- Class Public Methods

#pragma mark -- Function Private Methods

#pragma mark -- Function Public Methods

#pragma mark -- Instance Private Methods

#pragma mark -- Instance Public Methods

#pragma mark -- UserDidSelectDelegate

- (void)userDidSelect:(User*)user {
    //点击了自己，就跳转到我界面
    if(user.uid == _userManager.user.uid) {
        [self.navigationController.tabBarController setSelectedIndex:2];
    }
    else {//进入聊天界面
        PrivateChatController *privateChat = [[PrivateChatController alloc] initWithTargetId:@(user.uid).stringValue];
        privateChat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:privateChat animated:YES];
    }
}

@end
