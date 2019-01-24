//
//  IMSocketModules.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketModules.h"
#import "IMSocketControl.h"

@interface IMSocketModules () {
    /**Socket控制中心*/
    IMSocketControl *_iMSocketControl;
    /**用户消息监听*/
    IMSocketUserHandler *_iMSocketUserHandler;
    /**消息消息监听*/
    IMSocketMessageHandler *_iMSocketMessageHandler;
}
@end

@implementation IMSocketModules

#pragma mark -- Init Methods

- (instancetype)init {
    self = [super init];
    if(!self) {
        return nil;
    }
    
    //socket控制中心
    _iMSocketControl = [IMSocketControl new];
    //初始化user消息监听者
    _iMSocketUserHandler = [IMSocketUserHandler new];
    //设置IMSocketControl，方便_iMSocketUserHandler向IMSocketControl添加请求
    [_iMSocketUserHandler setControl:_iMSocketControl];
    //初始化msg消息监听者
    _iMSocketMessageHandler = [IMSocketMessageHandler new];
    [_iMSocketMessageHandler setControl:_iMSocketControl];
    
    //向_iMSocketControl注册user的监听者为_iMSocketUserHandler
    [_iMSocketControl regeistReceiver:@"user" interface:_iMSocketUserHandler];
    //向_iMSocketControl注册user的监听者为_iMSocketUserHandler
    [_iMSocketControl regeistReceiver:@"msg" interface:_iMSocketMessageHandler];
    return self;
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

#pragma mark -- Public Methods

- (void)connect:(NSString *)host port:(UInt16)port connectCallBack:(CallBackBlock)call disconnectCallBack:(CallBackBlock)disCall {
    [_iMSocketControl connect:host port:port callBack:call disconnectCallBack:disCall];
}

- (void)disconnect {
    [_iMSocketControl disconnect];
}

- (IMSocketUserHandler *)userHandler {
    return _iMSocketUserHandler;
}

- (IMSocketMessageHandler *)messageHandler {
    return _iMSocketMessageHandler;
}

@end
