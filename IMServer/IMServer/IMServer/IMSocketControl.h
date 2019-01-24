//
//  IMSocketControl.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketListener.h"
#import "IMSocketReceiver.h"
#import "IMSocketReqContext.h"

/**
 接收请求并发起，接收响应并转发
 在这里面注册你想要监听的消息，比如user、friend、message、notifation
 */
@interface IMSocketControl : NSObject

/**
 注册一个消息接受类型  cmd为：user用户登录、msg消息发送、friend关系改变、group群聊

 @param cmd 类型
 @param inter 监听者
 */
- (void)regeistReceiver:(NSString *)cmd interface:(id<IMSocketReceiver>)inter;

/**
 开始连接

 @param host host
 @param port port
 @param call 连接回调
 @param disCall 失去连接回调
 */
- (void)connect:(NSString *)host port:(UInt16)port callBack:(CallBackBlock)call disconnectCallBack:(CallBackBlock)disCall;

/**
 断开连接
 */
- (void)disconnect;

/**
 设置当前用户唯一标识符

 @param imid imid
 */
- (void)setImId:(uint64_t)imid;

/**
 添加一个请求

 @param reqContext 请求
 */
- (void)addReqContext:(IMSocketReqContext *)reqContext;

@end
