//
//  IMSocketIO.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketHeader.h"

//哪个端主动断开的连接
typedef enum {
    /**服务器断开链接，需要马上重连*/
    E_SOCKET_DISCONNECT_BY_SERVER   = 1,
    /**客户端断开链接，不需要重连*/
    E_SOCKET_DISCONNECT_BY_CLIENT   = 2
} E_SOCKET_DISCONNECT_TYPE;

/**
 数据传输协议
 */
@protocol IMSocketIODelegate <NSObject>
@optional

/**
 已经连接到了服务器

 @param host host
 @param port port
 */
- (void)didConnectToHost:(NSString *)host port:(UInt16)port;

/**
 已经从服务器断开连接

 @param host host
 @param port port
 @param err 错误原因
 */
- (void)didDisconnectHost:(NSString *)host port:(UInt16)port error:(NSError *)err;

/**
 收到了服务器传过来的数据，并且处理成一个完整的包 向外转发

 @param header 包头
 @param bodyData 包体
 */
- (void)didReceiveWithHeader:(IMSocketHeader *)header bodyData:(NSData *)bodyData;

@end

/**
 这个类才是最后发送数据，接收到一个完整的包后向delegate转发
 */
@interface IMSocketIO : NSObject

/**IMSocketIODelegate代理对象*/
@property (nonatomic,assign) id<IMSocketIODelegate> delegate;
/**
 建立连接

 @param host host
 @param port port
 */
- (void)creatConnetWithHost:(NSString *)host withPort:(UInt16)port;

/**
 断开连接
 */
- (void)disonnetSocket;

/**
 是否连接

 @return 是否连接
 */
- (BOOL)isSocketConnect;

/**
 发送消息

 @param data 消息内容
 @param type 包类型：心跳、通用、登录、退出
 */
- (void)sendData:(NSData *)data headerType:(E_SOCKET_HEADER_CMD_TYPE)type;

@end
