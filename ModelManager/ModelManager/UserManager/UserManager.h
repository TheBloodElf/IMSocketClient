//
//  UseManager.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "User.h"

/**
 应用体系中的数据库管理器，所有的数据操作通过本类完成
 聊天体系有单独的manager
 */
@interface UserManager : NSObject

/**当前登录的用户*/
@property (nonatomic, strong) User *user;

/**
 创建单例方法
 
 @return 单例对象
 */
+ (instancetype)manager;

/**
 更新当前登录用户信息

 @param user 最新的用户信息
 */
- (void)updateCurrUser:(User*)user;

/**
 获取所有的应用体系中的用户
 
 @return 用户
 */
- (NSMutableArray<User*>*)allUsers;

@end

