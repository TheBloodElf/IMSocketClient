//
//  IMSocketCallBackBlock.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#ifndef CMChatSocket_IMSocketCallBackBlock_h
#define CMChatSocket_IMSocketCallBackBlock_h

@class IMSocketRespAgent;

/**
 收到服务器的消息后，会经过各个模块处理成对应模块接收的IMSocketRespAgent对象

 @param resp 代理对象
 */
typedef void (^CallBackBlock)(IMSocketRespAgent* resp);

#endif
