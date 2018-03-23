//
//  IMUserManager.h
//  IMServer
//
//  Created by Mac on 2018/3/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Chater.h"

/**
聊天体系中的数据库管理器，所有的数据操作通过本类完成
应用体系有单独的manager
*/
@interface IMUserManager : NSObject

/**当前登录的聊天用户*/
@property (nonatomic, strong) Chater *chater;

/**
 创建单例方法
 
 @return 单例对象
 */
+ (instancetype)manager;

/**
 更新当前登录的聊天用户信息
 
 @param chater 最新的用户信息
 */
- (void)updateCurrChater:(Chater*)chater;

@end
