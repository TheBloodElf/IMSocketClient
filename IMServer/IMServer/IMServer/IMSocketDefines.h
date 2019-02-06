//
//  IMSocketDefines.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#ifndef IMSocketControl_IMSocketDefines_h
#define IMSocketControl_IMSocketDefines_h

/**
 包类型，放在包头部的type中
 */
typedef NS_ENUM(int, E_SOCKET_HEADER_CMD_TYPE) {
    /**连接建立时的"握手"包 其实系统提供的Socket接口已经做了握手的处理，我们发这个包只是为了获取数据加密密钥 换一个角度理解就是：我们自己客户端和服务器还需要确认一次连接，服务器好准备一些数据*/
    E_SOCKET_HEADER_CMD_HANDSHAKE   = 1,
    /**公共包（发送、接收消息都是这个类型）*/
    E_SOCKET_HEADER_CMD_COMMON      = 2,
    /**维持连接的心跳包*/
    E_SOCKET_HEADER_CMD_KEEPALIVE   = 3,
    /**登录包*/
    E_SOCKET_HEADER_CMD_LOGIN       = 4,
    /**退出登录包*/
    E_SOCKET_HEADER_CMD_LOGOUT      = 5
};

/**
 Socket连接状态 在IMUserSocket中使用，作为连接->登录->登录完成的标志
 */
typedef NS_ENUM(int, IM_SOCKET_STATUS) {
    /**默认状态*/
    IM_SOCKET_STATUS_NONE = 0,
    /**正在登录状态*/
    IM_SOCKET_STATUS_LOGINING,
    /**已经登录成功*/
    IM_SOCKET_STATUS_LOGINED,
};

/**
 客户端类型
 */
typedef NS_ENUM(int, E_SOCKET_CLIENT_TYPE) {
    /**未知客户端类型*/
    E_SOCKET_CLIENT_TYPE_UNKNOWN        = 1,
    /**Web客户端*/
    E_SOCKET_CLIENT_TYPE_PC_WEB         = 2,
    /**Android客户端*/
    E_SOCKET_CLIENT_TYPE_PHONE_ANDROID  = 3,
    /**iOS客户端*/
    E_SOCKET_CLIENT_TYPE_PHONE_IOS      = 4
};

/**
 聊天消息类型，客户端收到了在线类型的聊天消息需要发送ack
 */
typedef NS_ENUM(int, E_MSG_TYPE) {
    /**离线消息 你不在线时有人给你发消息，你在线后需要自己获取一次离线消息*/
    E_MSG_TYPE_OFFLINE = 1,
    /**在线消息 有人给你发聊天消息，统一叫做在线消息*/
    E_MSG_TYPE_ONLINE  = 2,
    /**漫游消息 用户换了设备，需要获取之前的聊天内容*/
    E_MSG_TYPE_ROAMMSG = 3
};

/**
 Socket错误码
 */
typedef NS_ENUM(int, E_SOCKET_ERROR) {
    /**成功*/
    E_SOCKET_ERROR_NONE             = 0,
    /**连接超时*/
    E_SOCKET_ERROR_TIME_OUT         = 1001,
    
    /**登录信息错误*/
    E_SOCKET_ERROR_LOGIN_INFO_ERROR   = 4001,
};

/**
 服务器返回的包类型
 */
typedef NS_ENUM(int, E_SERVER_PACK_TYPE) {
    /**请求包 服务器主动发起的请求，想要获取数据*/
    PACK_TYPE_REQ = 1,
    /**响应包 服务器响应客户端的请求*/
    PACK_TYPE_RESP = 2,
    /**消息包 转发的消息*/
    PACK_TYPE_NOTIFY = 3
};

/**
 消息内容类型
 */
typedef NS_ENUM(int, CHAT_CONTENT_TYPE) {
    /**文字消息*/
    E_CHAT_CONTENT_TYPE_TEXT        = 0,
    /**照片消息*/
    E_CHAT_CONTENT_TYPE_PHOTO       = 1,
    /**GIF消息*/
    E_CHAT_CONTENT_TYPE_GIF         = 2,
    /**音频消息*/
    E_CHAT_CONTENT_TYPE_AUDIO       = 3,
    /**位置消息*/
    E_CHAT_CONTENT_TYPE_ADDR        = 4,
    
    /**群通知消息 xxx退出群、加入群等*/
    E_CHAT_CONTENT_TYPE_GROUP_NOTIFY    = 20,
    /**群创建通知*/
    E_CHAT_CONTENT_TYPE_GROUP_CREATE_NOTIFY    = 21,
};

/**
  聊天消息发送状态
 */
typedef NS_ENUM(int, E_CHAT_SEND_STATUS) {
    /**发送中*/
    E_CHAT_SEND_STATUS_SENDING    = 0,
    /**已发送*/
    E_CHAT_SEND_STATUS_SENDED     = 1,
    /**失败*/
    E_CHAT_SEND_STATUS_SENDFIAL   = 2
};

/**
 聊天消息是来自哪里
 */
typedef NS_ENUM(int, E_CHAT_FROM_TYPE) {
    /**消息由我发出*/
    E_CHAT_FROM_ME      = 0,
    /**消息由其他人发出*/
    E_CHAT_FROM_OTHER   = 1,
};

#endif

