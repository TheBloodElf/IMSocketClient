//
//  CMUserModule.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketControl.h"
#import "IMSocketListener.h"
#import "IMSocketReqContext.h"

#pragma mark -- 登录
/**
 用户登录请求
 */
@interface UserLoginReq : NSObject

/**用户名 为用户提醒的uid字符串形式*/
@property (nonatomic, strong) NSString* username;
/**密码*/
@property (nonatomic, strong) NSString* passwd;
/**客户端版本号*/
@property (nonatomic, strong) NSString* client_version;
/**设备Token*/
@property (nonatomic, strong) NSString* device_token;

@end

/**
 用户登录响应
 */
@interface UserLoginResp : NSObject

/**用户唯一标识符*/
@property (nonatomic, assign) uint64_t imid;

@end

#pragma mark -- 被踢通知

/**
 用户被踢下线通知
 */
@interface UserKickoutNotify : NSObject

/**原因 1被T，其他原因后面慢慢发现*/
@property (nonatomic, assign) uint32_t reason;
/**哪个终端把你踢下线的*/
@property (nonatomic, assign) E_SOCKET_CLIENT_TYPE from_source_type;

@end


/**
 user消息监听者，主要是登录、设置用户信息等请求
 */
@interface IMSocketUserHandler : IMSocketListener <IMSocketReceiver>

/**
 设置控制中心

 @param control 控制中心
 */
- (void)setControl:(IMSocketControl *)control;

/**
 登录

 @param value 登录对象
 @param call 请求结果回调
 */
- (void)login:(UserLoginReq *)value function:(CallBackBlock)call;

@end
