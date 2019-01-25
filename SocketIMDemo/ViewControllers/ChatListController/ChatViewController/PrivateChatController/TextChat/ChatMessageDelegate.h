//
//  ChatMessageDelegate.h
//  SocketIMDemo
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class IMChatMesssage;

/**
 聊天消息代理
 */
@protocol ChatMessageDelegate <NSObject>

/**
 重新发送消息

 @param message 消息
 */
- (void)resendChatMessage:(IMChatMesssage*)message;

@end

NS_ASSUME_NONNULL_END
