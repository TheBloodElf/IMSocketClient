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
    //把IMSocketReqContext添加到IMSocketControl
    [_iMSocketControl addReqContext:reqContext];
}

#pragma mark -- IMSocketReceiver

- (void)receive:(IMSocketReqContext *)context {
    
}

@end
