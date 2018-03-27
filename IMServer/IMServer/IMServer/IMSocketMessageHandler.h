//
//  IMSocketMessageHandler.h
//  IMServer
//
//  Created by Mac on 2018/3/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "IMSocketControl.h"
#import "IMSocketListener.h"
#import "IMSocketReqContext.h"

#pragma mark -- 单聊消息

/**
 单聊消息，有人可能会比较疑惑，有了IMChatMesssage为啥还要定义一个MsgContent
 1：要和业务分离
 2：并不需要传IMChatMesssage中所有的字段
 3：这两个都是必须的，MsgContent用于socket，IMChatMesssage用于应用
 */
@interface MsgContent : NSObject

/**消息ID，该字段由客户端补充，现在直接从IMChatMesssage.id中取*/
@property (nonatomic, assign) int64_t msgid;
/**发送消息时填自己的终端类型，接收消息时为对方的终端类型*/
@property (nonatomic, assign) E_SOCKET_CLIENT_TYPE from_source_type;
/**发送消息时，自己的uid，接收消息时是对方的uid*/
@property (nonatomic, assign) int64_t sender_imid;
/**发送消息时，对方的uid,接收时自己的uid*/
@property (nonatomic, assign) int64_t reciver_imid;
/**消息时间，发送消息时可以不关心这个字段，由server填充，如果是接收方，则是收到该消息的时间，单位毫秒*/
@property (nonatomic, assign) int64_t time;
/**消息内容 是IMChatMesssage对象的json格式字符串*/
@property (nonatomic, strong) NSString *msg_data;

@end

/**
 发送单聊消息的响应
 */
@interface MsgSendResp : NSObject

@end

/**
 msg消息监听者，主要是发送聊天消息、收到聊天消息、收到推送消息等请求
 */
@interface IMSocketMessageHandler : IMSocketListener <IMSocketReceiver>

/**
 设置控制中心
 
 @param control 控制中心
 */
- (void)setControl:(IMSocketControl *)control;


/**
 发送单聊消息

 @param value 单聊消息
 @param call 发送结果
 */
- (void)send:(MsgContent*)value function:(CallBackBlock)call;

@end
