//
//  IMSocketModules.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketUserHandler.h"

/**
 聊天模块，只添加相应的IMSocketListener，不做其他的操作
 */
@interface IMSocketModules : NSObject

/**
 开始连接服务器

 @param host host
 @param port port
 @param call 连接成功回调
 @param disCall 连接断开回调
 */
- (void)connect:(NSString *)host port:(UInt16)port connectCallBack:(CallBackBlock)call disconnectCallBack:(CallBackBlock)disCall;

/**
 断开连接
 */
- (void)disconnect;

/**
 获取用户消息监听对象

 @return 用户消息监听对象
 */
- (IMSocketUserHandler *)userHandler;

@end
