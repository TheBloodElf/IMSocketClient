//
//  IMSocketReqContext.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketCallBackBlock.h"

/**
 传给IMSocketControl的请求对象，body根据cmd、sub_cmd、header_cmd设置不同的值
 同时会根据服务器返回的数据修改请求是的IMSocketControl对象的部分值，并向外传给IMSocketListener对象
 比如code为设置为服务器的响应结果，body设置为服务器的返回数据，type会根据情况改变
 */
@interface IMSocketReqContext : NSObject

/**请求结果回调*/
@property(nonatomic, strong) CallBackBlock handler;
/**错误码*/
@property(nonatomic, assign) E_SOCKET_ERROR code;
/**离线、在线、漫游消息 只在cmd为message时有用，其他地方暂时没用到*/
@property(nonatomic, assign) E_MSG_TYPE type;
/**发送失败后重试的次数（10s后重试） 超过两次后设置code为E_SOCKET_ERROR_TIME_OUT*/
@property(nonatomic, assign) int res;
/**区分心跳、通用、登录、退出等*/
@property(nonatomic, assign) E_SOCKET_HEADER_CMD_TYPE header_cmd;
/**区分user、group、friend、notifation等*/
@property(nonatomic, strong) NSString *cmd;
/**例如user区分login、logout、setinfo等*/
@property(nonatomic, strong) NSString *sub_cmd;
/**请求添加的时间，用于失败重发，设置请求超时*/
@property(nonatomic, strong) NSDate *time;
/**内容 json格式字符串 如cmd为user、sub_cmd为login，请求时则body为UserLoginReq对象的json格式字符串 响应时则body为UserLoginResp对象的json格式字符串*/
@property(nonatomic, strong) NSString *body;

@end
