//
//  IMUserManager.h
//  IMServer
//
//  Created by Mac on 2018/3/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMChater.h"
#import "IMChatMesssage.h"
#import "IMClientLog.h"

/**
 数据库中模型改变的回调通知
 */
typedef void(^ModelChangeHandler) (void);

/**
 聊天体系中的数据库管理器，所有的数据操作通过本类完成
 应用体系有单独的manager
 */
@interface IMUserManager : NSObject

/**当前登录的聊天用户*/
@property (nonatomic, strong) IMChater *chater;

/**
 创建单例方法
 
 @return 单例对象
 */
+ (instancetype)manager;

#pragma mark - IMChater

/**
 更新当前登录的聊天用户信息
 
 @param chater 最新的用户信息
 */
- (void)updateCurrChater:(IMChater*)chater;

#pragma mark - IMChatMesssage

/**
 创建或更新单聊消息

 @param message 消息内容
 */
- (void)updateChatMessage:(IMChatMesssage*)message;

/**
 创建用户的数据库观察者

 @param changeHandler 回调通知
 */
- (void)addChatMessageChangeListener:(ModelChangeHandler)changeHandler;

#pragma mark - IMClientLog

/**
 创建或更新日志消息
 
 @param clientLog 日志内容
 */
- (void)updateClientLog:(IMClientLog*)clientLog;

/**
 获取所有的日志

 @return 日志
 */
- (NSMutableArray<IMClientLog*>*)allClientLogs;

/**
 删除所有的日志
 */
- (void)deleteClientLogs;

/**
 创建日志的数据库观察者
 
 @param changeHandler 回调通知
 */
- (void)addClientLogChangeListener:(ModelChangeHandler)changeHandler;

@end
