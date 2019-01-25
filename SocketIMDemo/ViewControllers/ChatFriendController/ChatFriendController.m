//
//  ChatFriendController.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "ChatFriendController.h"

//Tools

//Views
#import "ChatFriendTableCell.h"

//Controllers
#import "PrivateChatController.h"

@interface ChatFriendController ()<UITableViewDelegate,UITableViewDataSource> {
    /**用户数据管理器*/
    UserManager *_userManager;
    
    /**表格视图*/
    UITableView *_tableView;
    /**数据源*/
    NSArray<User*> *_allUsers;
    
    /**是不是第一次显示界面*/
    BOOL _isFirstLoad;
}

@end

@implementation ChatFriendController

#pragma mark - Init Method

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"好友";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化模型、视图
    [self initModesAndViews];
    //添加点击事件
    [self setViewsClickEvents];
    //设置界面圆角、边框或者其他操作
    [self setViewsRoundLineOrOtherOperation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(!_isFirstLoad) {
        return;
    }
    _isFirstLoad = false;
    
    NSMutableArray<User*> *tempUsers = [@[] mutableCopy];
    for (User *user in [_userManager allUsers]) {
        //把自己排除掉
        if(user.uid == _userManager.user.uid) {
            continue;
        }
        
        [tempUsers addObject:user];
    }
    _allUsers = [tempUsers copy];
    [_tableView reloadData];
}

#pragma mark - Class Method

#pragma mark - Override Method

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!_allUsers) {
        return 0;
    }
    return _allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatFriendTableCell *friendTableCell = [tableView dequeueReusableCellWithIdentifier:@"ChatFriendTableCell"];
    
    //数据源被恶意修改
    if(!_allUsers || (indexPath.row >= _allUsers.count)) {
        return friendTableCell;
    }
    User *currUser = _allUsers[indexPath.row];
    friendTableCell.data = currUser;
    
    return friendTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *currUser = _allUsers[indexPath.row];
    PrivateChatController *privateVC = [[PrivateChatController alloc] initWithTargetId:currUser.uid];
    privateVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:privateVC animated:YES];
}

#pragma mark - Function Method

#pragma mark - Private Method

/**
 初始化模型、视图
 */
- (void)initModesAndViews {
    _isFirstLoad = true;
    //用户模型
    _userManager = [UserManager manager];
    //数据源
    _allUsers = @[];
    
    //表格视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [_tableView registerNib:[UINib nibWithNibName:@"ChatFriendTableCell" bundle:nil] forCellReuseIdentifier:@"ChatFriendTableCell"];
    [self.view addSubview:_tableView];
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
