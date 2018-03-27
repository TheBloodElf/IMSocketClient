//
//  IMUserSocket.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMChatMesssage.h"

/**
 用户聊天总类
 */
@interface IMUserSocket : NSObject

/**
 创建IMUserSocket单例

 @return 单例对象
 */
+ (instancetype)socket;

/**
 连接
 */
- (void)connect;

/**
 断开连接，理应断开后马上重连，因为哪个端主动断开的标志在IMSocketIO中，因为封装的逻辑并没有传到IMUserSocket中，所以我们在IMSocketControl的disconnect方法中设置了_disconnectCallBackBlock = nil，这样才实现了客户端主动断开连接不会重连的逻辑，当然这样的做法并不是很好，设计还需要再考虑
 */
- (void)disconnect;

/**
 发送单聊消息到服务器

 @param chatMessage 单聊聊天消息
 */
- (void)sendChatMessage:(IMChatMesssage*)chatMessage;

@end
