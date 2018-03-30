//
//  ChatMineTableViewManager.m
//  SocketIMDemo
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ChatMineTableViewManager.h"

#import "ChatLogTableCell.h"

@interface ChatMineTableViewManager () {
    /**表格视图*/
    UITableView *_tableView;
    /**需要展示的日志数据*/
    NSMutableArray<IMClientLog*> *_logs;
}
@end

@implementation ChatMineTableViewManager

#pragma mark -- Init Methods

- (instancetype)initWithLogs:(NSMutableArray<IMClientLog*>*)logs tableView:(UITableView*)tableView {
    if(self = [super init]) {
        _tableView = tableView;
        _logs = [logs mutableCopy];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setEstimatedRowHeight:80];
        [_tableView registerNib:[UINib nibWithNibName:@"ChatLogTableCell" bundle:nil] forCellReuseIdentifier:@"ChatLogTableCell"];
    }
    return self;
}

#pragma mark -- Class Private Methods

#pragma mark -- Class Public Methods

#pragma mark -- Function Private Methods

#pragma mark -- Function Public Methods

#pragma mark -- Instance Private Methods

#pragma mark -- Instance Public Methods

- (void)updateLogs:(NSMutableArray<IMClientLog*>*)logs {
    _logs = [logs mutableCopy];
    [_tableView reloadData];
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _logs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatLogTableCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ChatLogTableCell" forIndexPath:indexPath];
    
    IMClientLog *clientLog = _logs[indexPath.row];
    tableViewCell.logLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d %@",clientLog.date.hour,clientLog.date.minute,clientLog.date.second,clientLog.message];
    
    return tableViewCell;
}

@end
