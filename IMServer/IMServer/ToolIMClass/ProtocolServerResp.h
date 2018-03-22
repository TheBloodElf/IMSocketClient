//
//  ProtocolServerResp.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

/**
 服务器返回的data可以转变成ProtocolServerResp对象
 */
@interface ProtocolServerResp : NSObject

/**请求唯一标识符，和ProtocolClientReq的seq保持一致返回给客户端*/
@property(nonatomic, assign) int seq;
/**服务器返回的包类型*/
@property(nonatomic, assign) E_SERVER_PACK_TYPE type;
/**错误码*/
@property(nonatomic, assign) E_SOCKET_ERROR code;
/**区分user、group、friend、notifation等*/
@property(nonatomic, strong) NSString *cmd;
/**例如user区分login、logout、setinfo等*/
@property(nonatomic, strong) NSString *sub_cmd;
/**内容 json格式字符串 如cmd为user、sub_cmd为login，则body为UserLoginReq对象的json格式字符串*/
@property(nonatomic, strong) NSString *body;

@end

