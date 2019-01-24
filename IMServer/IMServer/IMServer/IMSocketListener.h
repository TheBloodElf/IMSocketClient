//
//  IMSocketListener.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketRespAgent.h"
#import "IMSocketCallBackBlock.h"

/**
 observers中的value对象
 */
@interface HandlerObject : NSObject

/**代理回调*/
@property (nonatomic, copy) CallBackBlock handler;

@end

/**
 注册类型对应的该类型的监听者
 */
@interface IMSocketListener : NSObject

/**
 添加一个类型对应的回调

 @param type 类型
 @param call 回调
 */
- (void)addEventListener:(NSString*)type withFunction:(CallBackBlock)call;

/**
 删除一个类型对应的回调

 @param type 类型
 @param call 回调
 */
- (void)removeEventListner:(NSString*)type withFunction:(CallBackBlock)call;

/**
 分发消息给该类型的所有HandlerObject对象，需要addEventListener添加对应的HandlerObject

 @param type 类型
 @param agent 分发内容
 */
- (void)dispach:(NSString*)type withAgent:(IMSocketRespAgent*)agent;

@end
