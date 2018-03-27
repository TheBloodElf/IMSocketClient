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

/**
 更新当前登录的聊天用户信息
 
 @param chater 最新的用户信息
 */
- (void)updateCurrChater:(IMChater*)chater;

/**
 创建或更新单聊消息

 @param message 消息内容
 */
- (void)updateChatMessage:(IMChatMesssage*)message;

@end
