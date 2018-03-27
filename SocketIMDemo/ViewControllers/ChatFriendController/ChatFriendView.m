//
//  ChatFriendView.m
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChatFriendView.h"

@interface ChatFriendView () {
    /**表格视图*/
    UITableView *_tableView;
}

@end

@implementation ChatFriendView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.tag = FRIEND_TABLEVIEW_TAG;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
    }
    return self;
}

@end
