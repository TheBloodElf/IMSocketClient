//
//  IMSocketIO.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketIO.h"

/**读取数据超时时间*/
#define DF_SOCKET_READ_TIMEOUT      -1
/**写入数据超时时间*/
#define DF_SOCKET_WRITE_TIMEOUT     -1

@interface IMSocketIO() <GCDAsyncSocketDelegate> {
    /**接收服务器发回来的数据*/
    NSMutableData *_mutableData;
}
/**tcp协议的socket句柄*/
@property(nonatomic,strong) GCDAsyncSocket *gCDAsyncSocket;
/**服务器地址*/
@property(nonatomic,strong) NSString *socketHost;
/**服务器端口号*/
@property(nonatomic,assign) UInt16 socketPort;

@end

@implementation IMSocketIO

#pragma mark -- Init Methods

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableData = [NSMutableData new];
        //初始化socket
        _gCDAsyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

/**
 收到了部分数据

 @param data 数据内容
 */
- (void)handleReceivedData:(NSData *)data {
    //加一个原子操作，保证这部分数据分析完成再分析下一部分数据
    @synchronized(self) {
        //添加到_mutableData中，试着解析数据
        [_mutableData appendData:data];
        [self tryParseReceivedData];
    }
}

/**
 试着解析数据 这里面处理了、分包、粘包、错误包的情况
 */
- (void)tryParseReceivedData {
    //头部都没有获取完，不解析 说明还没有获取到有body的部分
    if ([_mutableData length] < DF_SOCKET_HEADER_LENGTH) {
        return;
    }
    //提取 包头部
    IMSocketHeader *header = [[IMSocketHeader alloc] init];
    NSData *headerData = [_mutableData subdataWithRange:NSMakeRange(0, DF_SOCKET_HEADER_LENGTH)];
    [header setProperty:headerData];
    // 校验数据 如果数据校验没有通过，就去掉这部分数据
    if (header.magic_num != DF_SOCKET_HEADER_MAGIC_NUM) {
        [_mutableData setData:[NSData data]];
        return;
    }
    //头部指出了body的长度，如果现在接收的不完整，就不处理  分包情况
    if (header.body_len > ([_mutableData length] - DF_SOCKET_HEADER_LENGTH)) {
        return;
    }
    //当前数据池有一整个body数据
    NSData *dataBody = [_mutableData subdataWithRange:NSMakeRange(DF_SOCKET_HEADER_LENGTH, header.body_len)];
    if(_delegate && [_delegate respondsToSelector:@selector(didReceiveWithHeader:bodyData:)]) {
        [_delegate didReceiveWithHeader:header bodyData:dataBody];
    }
    //如果数据中有超过一个完整包的部分，去除头与body，保留剩余部分，再次解析 粘包
    if ([_mutableData length] - DF_SOCKET_HEADER_LENGTH - header.body_len > 0) {
        NSInteger loc = DF_SOCKET_HEADER_LENGTH + header.body_len;
        NSInteger len = [_mutableData length] - loc;
        [_mutableData setData:[_mutableData subdataWithRange:NSMakeRange(loc, len)]];
        [self tryParseReceivedData];
    } else {//出现错误，去掉这部分数据
        [_mutableData setData:[NSData data]];
    }
}

#pragma mark -- Public Methods

- (void)creatConnetWithHost:(NSString *)host withPort:(UInt16)port {
    _socketHost = host;//写入服务器ip
    _socketPort = port;//写入服务器端口
    [self disonnetSocket];//先断开链接，再重新连接
    _gCDAsyncSocket.userData = @(E_SOCKET_DISCONNECT_BY_SERVER);//设置默认主动断开端为服务器，这样连接失败后可以自动重连
    [_gCDAsyncSocket connectToHost:host onPort:port error:nil];
}

- (void)disonnetSocket {
    _gCDAsyncSocket.userData = @(E_SOCKET_DISCONNECT_BY_CLIENT);
    //会执行一次socketDidDisconnect:withError:方法
    [_gCDAsyncSocket disconnect];
}

- (BOOL)isSocketConnect {
    return [_gCDAsyncSocket isConnected];
}

- (void)sendData:(NSData *)data headerType:(E_SOCKET_HEADER_CMD_TYPE)type {
    //连接中断了 断开连接
    if(![_gCDAsyncSocket isConnected]){
        _gCDAsyncSocket.userData = @(E_SOCKET_DISCONNECT_BY_SERVER);
        [_gCDAsyncSocket disconnect];
        return;
    }
    //创建一个消息头部 里面有
    IMSocketHeader *header = [[IMSocketHeader alloc] init];
    header.body_len = data ? (int)data.length : 0;
    //设置消息类型 握手、登录、退出、被踢下线、公告
    header.command = type;
    NSData *headerData = [header getHeaderData];
    NSMutableData *send_data = [headerData mutableCopy];
    //如果有发送的数据，就把数据加到头部后面
    if (data) {
        [send_data appendData:data];
    }
    //发送封装好的数据
    [_gCDAsyncSocket writeData:send_data withTimeout:DF_SOCKET_WRITE_TIMEOUT tag:0];
    [_gCDAsyncSocket readDataWithTimeout:DF_SOCKET_READ_TIMEOUT tag:0];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    //开始接收数据
    [_gCDAsyncSocket readDataWithTimeout:DF_SOCKET_READ_TIMEOUT tag:0];
    if(_delegate && [_delegate respondsToSelector:@selector(didConnectToHost:port:)]){
        [_delegate didConnectToHost:host port:port];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //继续接收数据
    [_gCDAsyncSocket readDataWithTimeout:DF_SOCKET_READ_TIMEOUT tag:0];
    //处理数据
    [self handleReceivedData:data];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    if(_delegate && [_delegate respondsToSelector:@selector(didDisconnectHost:port:error:)]) {
        [_delegate didDisconnectHost:_socketHost port:_socketPort error:err];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

@end

