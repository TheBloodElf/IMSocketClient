//
//  IMUserSocket.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMUserSocket.h"
#import "IMSocketModules.h"
#import "IMHostResolver.h"

#import "IMUserManager.h"

/**IMUserSocket单例对象*/
static IMUserSocket * USER_IMSOCKET_SINGLETON = nil;
/**断开连接后，与服务器重连次数*/
static const int RECONNECT_SERVER_COUNT = 5;

@interface IMUserSocket ()<IMHostResolverDelegate> {
    /**当前Socket状态*/
    IM_SOCKET_STATUS _socketStatus;
    /**聊天模块，需要接收什么消息就注册在模块中*/
    IMSocketModules *_iMSocketModules;
    /**域名解析*/
    IMHostResolver *_hostResolver;
    
    /**当前重连次数*/
    int _currReConnectCount;
}

@end

@implementation IMUserSocket

#pragma mark -- Init Methods

- (instancetype)init {
    self = [super init];
    if(!self) {
        return NULL;
    }
    
    //重连次数重置为0
    _currReConnectCount = 0;
    //初始化socket状态为默认状态
    _socketStatus = IM_SOCKET_STATUS_NONE;
    //聊天模块初始化
    _iMSocketModules = [IMSocketModules new];
    //初始化域名解析
    _hostResolver = [[IMHostResolver alloc] initWithName:@"localhost"];
    _hostResolver.delegate = self;
    
    //注册被踢下线的回调
    [_iMSocketModules.userHandler addEventListener:@"kickout" withFunction:^(IMSocketRespAgent *resp) {
        [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:@"被踢下线。"]];
        //断开连接
        [self disconnect];
    }];
    //注册收到消息的通知
    [_iMSocketModules.messageHandler addEventListener:@"msg" withFunction:^(IMSocketRespAgent *resp) {
        MsgContent *content = (MsgContent *)resp.content;
        IMChatMesssage *chatMessage = [IMChatMesssage new];
        [chatMessage mj_setKeyValues:content.msg_data.mj_keyValues];
        //添加到数据库
        [[IMUserManager manager] updateChatMessage:chatMessage];
        [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"收到消息：%@。",@(content.msg_id)]]];
        //如果是在线消息，需要发送回执 这个回执用"对方已读"功能
        if(resp.type == E_MSG_TYPE_ONLINE) {
            MsgAckContent *ackContent = [MsgAckContent new];
            ackContent.ack_msgid = content.msg_id;
            ackContent.ack_source_type = E_SOCKET_CLIENT_TYPE_PHONE_IOS;
            ackContent.ack_imid = content.sender_imid;
            ackContent.sender_imid = content.reciver_imid;
            [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"向服务器发送ack消息：%@。",@(content.msg_id)]]];
            [self->_iMSocketModules.messageHandler send_ack:ackContent function:^(IMSocketRespAgent *resp) {
                [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"收到服务器ack消息：%@响应。",@(content.msg_id)]]];
            }];
        }
    }];
    return self;
}

#pragma mark -- Function Methods

#pragma mark -- Private Methods

/**
 进行连接操作
 */
- (void)execConnectProcesses {
    //得到解析出来的ip地址
    NSString *ipAdressString = _hostResolver.resolvedAddressStrings[0];
    //如果不合法，直接使用默认地址进行连接
    if([NSString isBlank:ipAdressString]) {
        ipAdressString = @"127.0.0.1";
    }
    //使用解析出来的地址进行连接
    else {
        NSArray *ipArray = [ipAdressString componentsSeparatedByString:@":"];
        //不为4个区间
        if(ipArray.count != 4) {
            ipAdressString = @"127.0.0.1";
        }
        else {
            //有空的区间
            for (NSString *string in ipArray) {
                if([NSString isBlank:string]) {
                    ipAdressString = @"127.0.0.1";
                    break;
                }
            }
        }
    }
    [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"正在连接到服务器：%@。",ipAdressString]]];
    //开始连接，地址要填写正确
    [_iMSocketModules connect:ipAdressString port:6868 connectCallBack:^(IMSocketRespAgent *resp) {
        //重连次数重置为0
        self->_currReConnectCount = 0;
        [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:@"已连接到服务器。"]];
        //连接错误
        if ([self transformCode:resp.code] != E_SOCKET_ERROR_NONE) {
            self->_socketStatus = IM_SOCKET_STATUS_NONE;
            [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:@"服务器连接失败。"]];
            return;
        }
        //设置连接状态为已经连接
        self->_socketStatus = IM_SOCKET_STATUS_LOGINED;
        //开始进行登录操作
        [self execLoginProcesses];
    } disconnectCallBack:^(IMSocketRespAgent *resp) {
        //超过重连次数，不进行重连
        if(self->_currReConnectCount >= RECONNECT_SERVER_COUNT) {
            //清除重连次数
            self->_currReConnectCount = 0;
            [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:@"重新连接服务器失败。"]];
            return ;
        }
        [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"进行第%@次重新连接服务器。",@(self->_currReConnectCount)]]];
        //连接断开，5s后重连
        self->_socketStatus = IM_SOCKET_STATUS_NONE;
        [self performSelector:@selector(connect) withObject:nil afterDelay:5.0f];
        self->_currReConnectCount ++;
    }];
}

/**
 进行登录操作
 */
- (void)execLoginProcesses {
    [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:@"向服务器发送登录请求。"]];
    //构建一个登录请求
    UserLoginReq *loginReq = [UserLoginReq new];
    //设置应用系统中的用户标志符
    loginReq.username = @([IMUserManager manager].chater.imid).stringValue;
    //TODO:设置获取到的设备Token，暂时设置为这个，后面做apns时再加
    loginReq.device_token = @"device_token";
    //开始登录
    [_iMSocketModules.userHandler login:loginReq function:^(IMSocketRespAgent *resp) {
        //登录错误，重设socket状态，之后不进行任何的处理
        if(resp.code != E_SOCKET_ERROR_NONE) {
            self->_socketStatus = IM_SOCKET_STATUS_NONE;
            [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:@"登录请求失败。"]];
            return;
        }
        [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:@"登录请求成功。"]];
        //状态为用户已经登录
        self->_socketStatus = IM_SOCKET_STATUS_LOGINED;
        //TODO：登录后应该拉取哪些内容 http://www.52im.net/thread-787-1-1.html
        //一次性拉取离线消息很卡怎么办 http://www.52im.net/thread-594-1-1.html
    }];
}

/**
 转换判断服务器返回的状态

 @param code 服务器返回的状态
 @return 转换后的结果
 */
- (int32_t)transformCode:(int32_t)code {
    if (code == 0 || code == 200000) {
        return E_SOCKET_ERROR_NONE;
    }
    return code;
}

#pragma mark -- Public Methods

+ (instancetype)socket {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        USER_IMSOCKET_SINGLETON = [[self class] new];
    });
    return USER_IMSOCKET_SINGLETON;
}

- (void)connect {
    @synchronized(self) {
        //如果socket状态是连接上的、正在连接，就不进行任何操作
        if (_socketStatus != IM_SOCKET_STATUS_NONE) {
            return;
        }
        //设置状态为正在连接状态，和正在登录用同一个状态
        _socketStatus = IM_SOCKET_STATUS_LOGINING;
        //如果没有解析的地址，开始解析
        if(_hostResolver.resolvedAddressStrings.count == 0) {
            [_hostResolver start];
            [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"对%@进行域名解析。",@"localhost"]]];
            return;
        }
        //进行连接操作
        [self execConnectProcesses];
    }
}

- (void)disconnect {
    //设置socket状态
    _socketStatus = IM_SOCKET_STATUS_NONE;
    [_iMSocketModules disconnect];
}

- (void)sendChatMessage:(IMChatMesssage*)chatMessage {
    //构造消息内容
    MsgContent *content = [MsgContent new];
    content.msg_id = chatMessage.msg_id;
    content.from_source_type = E_SOCKET_CLIENT_TYPE_PHONE_IOS;
    content.reciver_imid = chatMessage.reciver.imid;
    content.sender_imid = chatMessage.sender.imid;
    content.time = chatMessage.time;
    content.msg_data = [[chatMessage JSONDictionary] mj_JSONString];
    [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"向服务器发送消息：%@。",@(content.msg_id)]]];
    //发送消息
    [_iMSocketModules.messageHandler send:content function:^(IMSocketRespAgent *resp) {
        //发送失败
        if ([self transformCode:resp.code] != E_SOCKET_ERROR_NONE) {
            chatMessage.status = E_CHAT_SEND_STATUS_SENDFIAL;
            [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"消息：%@发送失败。",@(content.msg_id)]]];
        }
        //发送成功 并不代表对方已读
        else {
            chatMessage.status = E_CHAT_SEND_STATUS_SENDED;
            [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"消息：%@发送成功。",@(content.msg_id)]]];
        }
        //更新数据库
        [[IMUserManager manager] updateChatMessage:chatMessage];
    }];
}

#pragma mark -- IMHostResolverDelegate

- (void)hostResolverDidFinish:(IMHostResolver *)resolver {
    [resolver cancel];
    [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"%@域名解析成功。",@"localhost"]]];
    //进行连接操作
    [self execConnectProcesses];
}

- (void)hostResolver:(IMHostResolver *)resolver didFailWithError:(NSError *)error {
    [resolver cancel];
    [[IMUserManager manager] updateClientLog:[IMClientLog clientLogWithMessage:[NSString stringWithFormat:@"%@域名解析失败。",@"localhost"]]];
    //进行连接操作
    [self execConnectProcesses];
}

@end
