//
//  UseManager.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "User.h"
#import "Chater.h"

/**
 数据库管理器，所有的数据操作通过本类完成
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
 更新当前应用体系中的所有用户

 @param users 用户
 */
- (void)updateUsers:(NSMutableArray<User*>*)users;

/**
 获取所有的应用体系中的用户
 
 @return 用户
 */
- (NSMutableArray<User*>*)allUsers;

/**
 更新一个聊天体系中的用户

 @param chater 聊天体系中的用户
 */
- (void)updateChater:(Chater*)chater;

/**
 获取指定imid中的用户，肯定是能获取到的，因为我们会先进行updateChater操作
 
 @return 用户
 */
- (Chater*)chaterWithImid:(int64_t)imid;

@end

