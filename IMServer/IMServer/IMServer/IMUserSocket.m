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
static IMUserSocket * USER_IMSOCKET_SINGLETON;
/**断开连接后，与服务器重连次数*/
static int RECONNECT_SERVER_COUNT = 5;

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

- (id)init {
    if (self = [super init]) {
        //重连次数重置为0
        _currReConnectCount = 0;
        //初始化socket状态
        _socketStatus = IM_SOCKET_STATUS_NONE;
        //聊天模块初始化
        _iMSocketModules = [IMSocketModules new];
        //初始化域名解析
        _hostResolver = [[IMHostResolver alloc] initWithName:@"localhost"];
        _hostResolver.delegate = self;
        
        //注册被踢下线的回调
        [_iMSocketModules.userHandler addEventListener:@"kickout" withFunction:^(IMSocketRespAgent *resp) {
            //断开连接
            [self disconnect];
        }];
    }
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
    //开始连接，地址要填写正确
    [_iMSocketModules connect:ipAdressString port:6868 connectCallBack:^(IMSocketRespAgent *resp) {
        //重连次数重置为0
        _currReConnectCount = 0;
        //连接错误
        if ([self transformCode:resp.code] != E_SOCKET_ERROR_NONE) {
            _socketStatus = IM_SOCKET_STATUS_NONE;
            return;
        }
        //设置连接状态为已经连接
        _socketStatus = IM_SOCKET_STATUS_LOGINED;
        //开始进行登录操作
        [self execLoginProcesses];
    } disconnectCallBack:^(IMSocketRespAgent *resp) {
        //超过重连次数，不进行重连
        if(_currReConnectCount >= RECONNECT_SERVER_COUNT) {
            //清除重连次数
            _currReConnectCount = 0;
            return ;
        }
        //连接断开，5s后重连
        _socketStatus = IM_SOCKET_STATUS_NONE;
        [self performSelector:@selector(connect) withObject:nil afterDelay:5.0f];
        _currReConnectCount ++;
    }];
}

/**
 进行登录操作
 */
- (void)execLoginProcesses {
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
            _socketStatus = IM_SOCKET_STATUS_NONE;
            return;
        }
        //状态为用户已经登录
        _socketStatus = IM_SOCKET_STATUS_LOGINED;
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

#pragma mark -- IMHostResolverDelegate

- (void)hostResolverDidFinish:(IMHostResolver *)resolver {
    [resolver cancel];
    //进行连接操作
    [self execConnectProcesses];
}

- (void)hostResolver:(IMHostResolver *)resolver didFailWithError:(NSError *)error {
    [resolver cancel];
    //进行连接操作
    [self execConnectProcesses];
}

@end
