//
//  IMProtocolServerResp.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

/**
 服务器返回的data可以转变成IMProtocolServerResp对象
 */
@interface IMProtocolServerResp : NSObject

/**请求唯一标识符，和ProtocolClientReq的seq保持一致返回给客户端*/
@property(nonatomic, assign) int seq;
/**服务器返回的包类型*/
@property(nonatomic, assign) E_SERVER_PACK_TYPE type;
/**错误码*/
@property(nonatomic, assign) E_SOCKET_ERROR code;
/**这里我们对cmd和sub_cmd的组合进行定义
 user-kickout：用户被踢下线
 msg-notify：转发聊天消息给你
 */
/**区分user、group、friend、notifation等*/
@property(nonatomic, strong) NSString *cmd;
/**例如user区分login、logout、setinfo等*/
@property(nonatomic, strong) NSString *sub_cmd;
/**应用版本号*/
@property(nonatomic, strong) NSString *version;
/**用户唯一标识符*/
@property(nonatomic, assign) int64_t imid;
/**内容 json格式字符串 如cmd为user、sub_cmd为login，则body为UserLoginReq对象的json格式字符串*/
@property(nonatomic, strong) NSString *body;

@end

