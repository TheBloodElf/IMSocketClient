//
//  IMSocketReceiver.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#ifndef CMChatSocket_IMSocketReceiver_h
#define CMChatSocket_IMSocketReceiver_h

@class IMSocketReqContext;

/**
 消息接收协议
 */
@protocol IMSocketReceiver <NSObject>

@required

/**
 该请求接收到了响应

 @param context 请求+响应内容
 */
- (void)receive:(IMSocketReqContext *)context;

@end

#endif
