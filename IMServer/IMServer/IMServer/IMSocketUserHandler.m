//
//  IMSocketUserHandler.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketUserHandler.h"

@interface IMSocketUserHandler () {
    IMSocketControl *_iMSocketControl;
}

@end

#pragma mark -- 登录

@implementation UserLoginReq

- (instancetype)init {
    self = [super init];
    if (self) {
        //登录密码，默认为此，不然服务器会返回错误
        _passwd = @"bb_password";
        //版本号
        _client_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        //设备Token，后面注册apns时可以得到正确的值进行传输
        _device_token = @"bb_token";
    }
    return self;
}

@end

@implementation UserLoginResp

@end

#pragma mark -- 被踢通知

@implementation UserKickoutNotify

@end

@implementation IMSocketUserHandler

#pragma mark -- Public Methods

- (void)setControl:(IMSocketControl *)control {
    _iMSocketControl = control;
}

- (void)login:(UserLoginReq *)value function:(CallBackBlock)call {
    //构造一个IMSocketReqContext
    IMSocketReqContext *reqContext = [IMSocketReqContext new];
    reqContext.cmd = @"user";
    reqContext.sub_cmd = @"login";
    reqContext.header_cmd = E_SOCKET_HEADER_CMD_LOGIN;
    reqContext.handler = call;
    reqContext.body = [value mj_JSONString];
    //把IMSocketReqContext添加到IMSocketControl
    [_iMSocketControl addReqContext:reqContext];
}

#pragma mark -- IMSocketReceiver

/**
 发起的请求，已经收到服务器的响应，结合context和sub_cmd处理成IMSocketRespAgent对象往外分发

 @param context 请求
 */
- (void)receive:(IMSocketReqContext*)context {
    //初始化一个代理对象
    IMSocketRespAgent *respAgent = [IMSocketRespAgent new];
    respAgent.cmd = context.cmd;//本类中固定为user
    respAgent.sub_cmd = context.sub_cmd;//login等
    respAgent.code = context.code;
    respAgent.type = context.type;
    //如果是登录，且有数据
    if(context.body && [respAgent.sub_cmd isEqualToString:@"login"]) {
        //登录成功后会返回UserLoginResp对象的data
        UserLoginResp *resp = [UserLoginResp new];
        [resp mj_setKeyValues:context.body.mj_keyValues];
        respAgent.content = resp;
        //给控制中心设置imid，后面的消息发送会传给服务器
        [_iMSocketControl setImId:resp.imid];
    }
    //如果是被踢下线，且有数据
    if(context.body && [respAgent.sub_cmd isEqualToString:@"kickout"]) {
        //被踢下线后会返回UserKickoutNotify对象的data
        UserKickoutNotify *resp = [UserKickoutNotify new];
        [resp mj_setKeyValues:context.body.mj_keyValues];
        respAgent.content = resp;
        //分发被踢下线的消息，因为kickout是通过addEventListener添加的
        [self dispach:@"kickout" withAgent:respAgent];
    }
    //如果该请求发起的时候有回调，就执行
    if(context.handler)
        context.handler(respAgent);
}

@end
