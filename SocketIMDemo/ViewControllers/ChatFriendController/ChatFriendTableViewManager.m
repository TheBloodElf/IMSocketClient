//
//  ChatFriendDataSourceDelegate.m
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChatFriendTableViewManager.h"

#import "ChatFriendTableCell.h"

@implementation ChatFriendTableViewManager {
    /**表格视图*/
    UITableView *_tableView;
    /**需要展示的用户数据*/
    NSMutableArray<User*> *_users;
}

#pragma mark -- Init Methods

- (instancetype)initWithUsers:(NSMutableArray<User*>*)users tableView:(UITableView*)tableView {
    if(self = [super init]) {
        _tableView = tableView;
        _users = [users mutableCopy];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ChatFriendTableCell" bundle:nil] forCellReuseIdentifier:@"ChatFriendTableCell"];
    }
    return self;
}

#pragma mark -- Class Private Methods

#pragma mark -- Class Public Methods

#pragma mark -- Function Private Methods

#pragma mark -- Function Public Methods

#pragma mark -- Instance Private Methods

#pragma mark -- Instance Public Methods

- (void)updateUsers:(NSMutableArray<User*>*)users {
    _users = [users mutableCopy];
    [_tableView reloadData];
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //向外传递结果
    if(self.userSelectDelegate && [self.userSelectDelegate respondsToSelector:@selector(userDidSelect:)]) {
        [self.userSelectDelegate userDidSelect:_users[indexPath.row]];
    }
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatFriendTableCell *friendTableCell = [tableView dequeueReusableCellWithIdentifier:@"ChatFriendTableCell" forIndexPath:indexPath];
    
    //得到当前cell对应的用户
    User *currUser = _users[indexPath.row];
    
    //设置界面
    friendTableCell.userName.text = currUser.nick;
    [friendTableCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:currUser.avatar] placeholderImage:[UIImage imageNamed:@"default_image_icon"]];
    
    return friendTableCell;
}

@end
