//
//  ChatMineTableViewManager.h
//  SocketIMDemo
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMineTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>

/**
 初始化方法
 
 @param logs 要展示的日志数据
 @param tableView 表格视图
 @return ChatMineTableViewManager对象
 */
- (instancetype)initWithLogs:(NSMutableArray<IMClientLog*>*)logs tableView:(UITableView*)tableView;

/**
 更新数据源
 
 @param logs 最新的要展示的日志数据
 */
- (void)updateLogs:(NSMutableArray<IMClientLog*>*)logs;

@end
