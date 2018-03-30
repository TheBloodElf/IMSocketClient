//
//  ChatMineView.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "ChatMineView.h"

@interface ChatMineView () {
    /**表格视图*/
    UITableView *_tableView;
}
@end

@implementation ChatMineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.tag = LOG_TABLE_VIEW_TAG;
        _tableView.tableFooterView = [UIView new];
        [self addSubview:_tableView];
    }
    return self;
}

@end
