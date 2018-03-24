//
//  ChatFriendDataSourceDelegate.h
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

/**
 用户被点击代理
 */
@protocol UserDidSelectDelegate <NSObject>

/**
 哪个用户被点击

 @param user 用户
 */
- (void)userDidSelect:(User*)user;

@end

/**
 好友表格视图管理器，按照Android思想，本类关心展示逻辑、样式，向外部传出结果
 */
@interface ChatFriendTableViewManager : NSObject<UITableViewDelegate,UITableViewDataSource>

/**
 用户被点击代理对象
 */
@property (nonatomic, weak) id<UserDidSelectDelegate> userSelectDelegate;

/**
 初始化方法 

 @param users 要展示的用户数据
 @param tableView 表格视图
 @return ChatFriendDataSourceDelegate对象
 */
- (instancetype)initWithUsers:(NSMutableArray<User*>*)users tableView:(UITableView*)tableView;

/**
 更新数据源

 @param users 最新的要展示的用户数据
 */
- (void)updateUsers:(NSMutableArray<User*>*)users;

@end
