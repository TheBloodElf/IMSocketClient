//
//  IMSocketControl.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketControl.h"
#import "IMSocketIO.h"
#import "IMProtocolClientReq.h"
#import "IMProtocolServerResp.h"

@interface IMSocketControl ()<IMSocketIODelegate> {
    /**用来获取每个请求对应的唯一标识符*/
    int _seq;
    /**用户唯一标识符*/
    uint64_t _imid;
    
    /**加密字符*/
    char _cryptKey;
    
    /**发送包数据句柄*/
    IMSocketIO *_iMSocketIO;
    /**连接成功回调*/
    CallBackBlock _connectCallBackBlock;
    /**断开连接回调*/
    CallBackBlock _disconnectCallBackBlock;
    
    /**不断的检查operationMaps中的操作，做10s超时重传处理，超过2次设置发送失败标志*/
    NSTimer *_timeOutTimer;
    /**发送心跳的定时器*/
    NSTimer *_heartbeatTimer;
}

@end

@implementation IMSocketControl

#pragma mark -- Init Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化属性
        _operationMaps = [@{} mutableCopy];
        _registerMaps = [@{} mutableCopy];
        //不断的定时检查operationMaps，判断发送失败、或者需要重试
        _timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimeOutTimer) userInfo:nil repeats:YES];
        //初始化IMSocketIO
        _iMSocketIO = [IMSocketIO new];
        _iMSocketIO.delegate = self;
    }
    return self;
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

/**
 获取请求唯一标识符

 @return 请求唯一标识符
 */
- (int)getSeq {
    @synchronized(self) {
        return _seq++;
    }
}


/**
 发送心跳
 */
-(void)handleHeartbeatTimer {
    if (_iMSocketIO && [_iMSocketIO isSocketConnect]) {
        [_iMSocketIO sendData:nil headerType:E_SOCKET_HEADER_CMD_KEEPALIVE];
    }
}

/**
 处理超时请求
 */
-(void)handleTimeOutTimer {
    @synchronized(self) {
        //现在的时间
        uint32_t nowTime = [[NSDate date] timeIntervalSince1970];
        //拷贝一份所有操作
        NSMutableDictionary *maps = [self.operationMaps mutableCopy];
        //循环里面的所有操作
        for (NSString *key in maps) {
            //得到请求对象
            IMSocketReqContext *context = [self.operationMaps objectForKey:key];
            //得到发起请求的时间
            uint32_t tempTime = [context.time timeIntervalSince1970];
            //如果超过了10s都还没有得到处理，我们就重新添加该请求，重试次数+1
            if (context.res < 2 && nowTime - tempTime > 10) {
                context.res ++;
                [self addReqContext:context];
                [self.operationMaps removeObjectForKey:key];
            }
            else if(context.res >= 2) {//如果已经重试两次了，设置失败，并通知对应cmd监听者
                id<IMSocketReceiver> receiver = [self.registerMaps objectForKey:context.cmd];
                if (receiver != nil) {
                    //连接超时
                    context.code = E_SOCKET_ERROR_TIME_OUT;
                    //在线消息
                    context.type = E_MSG_TYPE_ONLINE;
                    context.body = nil;
                    //通知监听者
                    [receiver receive:context];
                }
                [self.operationMaps removeObjectForKey:key];
            }
        }
    }
}

/**
 加解密数据

 @param data 数据
 @param cryptKey 加解密字符
 */
- (void)encryptData:(NSData*)data cryptKey:(char)cryptKey {
    char *crptyData = (char *)[data bytes];
    for(int i = 0; i< [data length]; i++) {
        *crptyData = (*crptyData)^cryptKey;
        crptyData++;
    }
}

#pragma mark -- Public Methods

- (void)setImId:(uint64_t)imid {
    _imid = imid;
    [_heartbeatTimer invalidate];
    _heartbeatTimer = nil;
    _heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(handleHeartbeatTimer) userInfo:nil repeats:YES];
}

- (void)regeistReceiver:(NSString *)cmd interface:(id<IMSocketReceiver>)inter {
    if (inter && ![self.registerMaps objectForKey:cmd]) {
        [self.registerMaps setObject:inter forKey:cmd];
    }
}

- (void)connect:(NSString *)host port:(UInt16)port callBack:(CallBackBlock)call disconnectCallBack:(CallBackBlock)disCall {
    _connectCallBackBlock = call;//连接成功回调
    _disconnectCallBackBlock = disCall;//连接失败回调
    [_iMSocketIO creatConnetWithHost:host withPort:port];
}

- (void)disconnect {
    //主动断开连接，清除断开连接回调 这样IMUserSocket内部就不会进行重连了
    _disconnectCallBackBlock = nil;
    //发送退出登录的消息
    if (_iMSocketIO && [_iMSocketIO isSocketConnect]) {
        [_iMSocketIO sendData:nil headerType:E_SOCKET_HEADER_CMD_LOGOUT];
    }
    //断开连接 如果完全按照四次挥手，这里不应该主动断开连接，应该收到服务器的ack确定才去断开
    //但是我们并没有完全按照四次挥手的标准来
    if (_iMSocketIO) {
        [_iMSocketIO disonnetSocket];
    }
    if (_heartbeatTimer) {
        [_heartbeatTimer invalidate];
        _heartbeatTimer = nil;
    }
}

- (void)addReqContext:(IMSocketReqContext *)reqContext {
    //这个方法会原子的执行完
    @synchronized(self) {
        //获取请求唯一标识符
        int seq = [self getSeq];
        //设置请求时间
        reqContext.time = [NSDate new];
        //把这个请求放到operationMaps中，用seq做唯一标识符
        [self.operationMaps setObject:reqContext forKey:@(seq).stringValue];
        //把reqContext封装成一个消息体，再转成NSData给SocketIO对象
        IMProtocolClientReq *clientReq = [IMProtocolClientReq new];
        clientReq.cmd = reqContext.cmd;
        clientReq.sub_cmd = reqContext.sub_cmd;
        clientReq.seq = seq;
        clientReq.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        clientReq.imid = _imid;
        //资源类型为ios
        clientReq.source_type = E_SOCKET_CLIENT_TYPE_PHONE_IOS;
        clientReq.body = reqContext.body;
        //把IMProtocolClientReq转换成NSData
        NSString *reqString = [clientReq mj_JSONString];
        NSData *reqData = [reqString dataUsingEncoding:NSUTF8StringEncoding];
        //加解密
        [self encryptData:reqData cryptKey:_cryptKey];
        //把data传给socketIO进行发送
        [_iMSocketIO sendData:reqData headerType:reqContext.header_cmd];
    }
}

#pragma mark -- IMSocketIODelegate

- (void)didConnectToHost:(NSString *)host port:(UInt16)port {
    [_iMSocketIO sendData:nil headerType:E_SOCKET_HEADER_CMD_HANDSHAKE];
}

- (void)didDisconnectHost:(NSString *)host port:(UInt16)port error:(NSError *)err {
    [_heartbeatTimer invalidate];
    _heartbeatTimer = nil;
    if (_disconnectCallBackBlock) {
        _disconnectCallBackBlock(nil);
    }
}

- (void)didReceiveWithHeader:(IMSocketHeader *)header bodyData:(NSData *)bodyData {
    //开始解析数据
    switch (header.command) {
            //握手数据不向外分发，自己处理，告诉外部连接成功
        case E_SOCKET_HEADER_CMD_HANDSHAKE:
            //获取加密字符 这也是单独握手一次的目的
            [bodyData getBytes:&_cryptKey length:1];
            //通知回调，连接完成
            _connectCallBackBlock(nil);
            break;
        default: {
            //加解密数据
            [self encryptData:bodyData cryptKey:_cryptKey];
            //开始解析数据
            [self parseContent:bodyData type:E_MSG_TYPE_ONLINE];
            break;
        }
    }
}

- (void)parseContent:(NSData*)data type:(E_MSG_TYPE)type {
    @synchronized(self) {
        //解析服务器的响应
        IMProtocolServerResp *serverResp = [IMProtocolServerResp new];
        NSString *serverString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [serverResp mj_setKeyValues:serverString.mj_keyValues];
        //得到该请求的cmd类别对应的监听者
        id<IMSocketReceiver> receiver = [self.registerMaps objectForKey:serverResp.cmd];
        if(receiver == nil)
            return;
        //判断该响应包的类型
        //如果是对某个请求的响应
        if(serverResp.type == PACK_TYPE_RESP) {
            //得到该响应对应的请求 并修改部分值
            IMSocketReqContext *reqContext = [self.operationMaps objectForKey:@(serverResp.seq).stringValue];
            //设置响应结果，成功还是失败
            reqContext.code = serverResp.code;
            //设置消息类型
            reqContext.type = type;
            //设置cmd 和 sub_cmd，理论上是不用设置的，因为addReqContext时已经设置了，但是为了保证万无一失
            reqContext.cmd = serverResp.cmd;
            reqContext.sub_cmd = serverResp.sub_cmd;
            //设置服务器返回的数据
            reqContext.body = serverResp.body;
            //通知监听者，请求已经得到回应了
            [receiver receive:reqContext];
            //该消息已经得到处理，从self.operationMaps中删除
            [self.operationMaps removeObjectForKey:@(serverResp.seq).stringValue];
        }
        //如果是通知，则self.registerMaps没有对应的响应，需要自己组装一个响应向外发送
        if(serverResp.type == PACK_TYPE_NOTIFY) {
            IMSocketReqContext *reqContext = [IMSocketReqContext new];
            //设置响应结果，成功还是失败
            reqContext.code = serverResp.code;
            //设置消息类型
            reqContext.type = type;
            //设置cmd 和 sub_cmd，理论上是不用设置的，因为addReqContext时已经设置了，但是为了保证万无一失
            reqContext.cmd = serverResp.cmd;
            reqContext.sub_cmd = serverResp.sub_cmd;
            //设置服务器返回的数据
            reqContext.body = serverResp.body;
            //通知监听者，请求已经得到回应了
            [receiver receive:reqContext];
        }
    }
}

@end
