//
//  IMSocketMessageHandler.m
//  IMServer
//
//  Created by Mac on 2018/3/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "IMSocketMessageHandler.h"

#pragma mark -- 单聊消息

@implementation MsgContent

@end

@implementation MsgSendResp

@end

@implementation MsgAckContent

@end

@implementation MsgSendAckResp

@end

@implementation MsgPushNotify

@end

@interface IMSocketMessageHandler () {
    IMSocketControl *_iMSocketControl;
}

@end

@implementation IMSocketMessageHandler

#pragma mark -- Init Methods

#pragma mark -- Class Private Methods

#pragma mark -- Class Public Methods

#pragma mark -- Function Private Methods

#pragma mark -- Function Public Methods

#pragma mark -- Instance Private Methods

#pragma mark -- Instance Public Methods

- (void)setControl:(IMSocketControl *)control {
    _iMSocketControl = control;
}

- (void)send:(MsgContent*)value function:(CallBackBlock)call {
    //构造一个IMSocketReqContext
    IMSocketReqContext *reqContext = [IMSocketReqContext new];
    reqContext.cmd = @"msg";
    reqContext.sub_cmd = @"send";
    reqContext.header_cmd = E_SOCKET_HEADER_CMD_COMMON;
    reqContext.handler = call;
    reqContext.body = [value mj_JSONString];
    reqContext.type = E_MSG_TYPE_ONLINE;
    //把IMSocketReqContext添加到IMSocketControl
    [_iMSocketControl addReqContext:reqContext];
}

- (void)send_ack:(MsgAckContent*)value function:(CallBackBlock)call {
    //构造一个IMSocketReqContext
    IMSocketReqContext *reqContext = [IMSocketReqContext new];
    reqContext.cmd = @"msg";
    reqContext.sub_cmd = @"send_ack";
    reqContext.header_cmd = E_SOCKET_HEADER_CMD_COMMON;
    reqContext.handler = call;
    reqContext.body = [value mj_JSONString];
    //把IMSocketReqContext添加到IMSocketControl
    [_iMSocketControl addReqContext:reqContext];
}

#pragma mark -- IMSocketReceiver

- (void)receive:(IMSocketReqContext *)context {
    //初始化一个代理对象
    IMSocketRespAgent *respAgent = [IMSocketRespAgent new];
    //本类中固定为msg
    respAgent.cmd = context.cmd ?: @"user";
    //login等
    respAgent.sub_cmd = context.sub_cmd;
    respAgent.code = context.code;
    respAgent.type = context.type;
    
    //消息发送成功
    if(context.body && [respAgent.sub_cmd isEqualToString:@"send"]) {
        MsgSendResp *resp = [MsgSendResp new];
        [resp mj_setKeyValues:context.body.mj_keyValues];
        respAgent.content = resp;
    }
    //消息回执发送成功
    if(context.body && [respAgent.sub_cmd isEqualToString:@"send_ack"]) {
        MsgSendAckResp *resp = [MsgSendAckResp new];
        [resp mj_setKeyValues:context.body.mj_keyValues];
        respAgent.content = resp;
    }
    //收到别人主动发的聊天消息
    if(context.body && [respAgent.sub_cmd isEqualToString:@"msg"]) {
        MsgContent *resp = [MsgContent new];
        [resp mj_setKeyValues:context.body.mj_keyValues];
        respAgent.content = resp;
        [self dispach:@"msg" withAgent:respAgent];
    }
    //如果该请求发起的时候有回调，就执行
    if(context.handler) {
        context.handler(respAgent);
    }
}

@end
