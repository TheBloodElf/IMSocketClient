//
//  IMSocketRespAgent.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

/**
 收到服务器的数据后，由IMSocketUserHandler结合对应的IMSocketReqContext处理后成为该对象向外转发
 */
@interface IMSocketRespAgent : NSObject

/**错误码*/
@property(nonatomic, assign) E_SOCKET_ERROR code;
/**离线、在线、漫游消息*/
@property(nonatomic, assign) E_MSG_TYPE type;
/**区分user、group、friend、notifation等*/
@property(nonatomic, strong) NSString *cmd;
/**例如user区分login、logout、setinfo等*/
@property(nonatomic, strong) NSString *sub_cmd;
/**例如user的login则是UserLoginResp对象*/
@property(nonatomic, strong) NSObject *content;

@end
