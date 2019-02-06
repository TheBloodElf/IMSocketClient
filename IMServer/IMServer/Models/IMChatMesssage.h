//
//  IMChatMesssage.h
//  IMServer
//
//  Created by Mac on 2018/3/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMChater.h"
#import "IMChatMessageContent.h"

/**
 单聊聊天消息，暂时设计到这些必需的属性
 相信大家看了属性列表之后，对于ownerImid和senderImid表示不理解存在的意义，那么我们举个例子。
 我们假设用户10001和10002在聊天，最开始10001、10002都没有任何记录。
 1：10001将要发送一条IMChatMesssage记录，会设置ownerImid为10002，senderImid为10001；但是没网发送失败了，10001则有一条失败的记录，10002没有记录。
 这时候10001客户端显示和10002所有消息时从数据库中获取ownerImid为10002的即可，只有一条；10002客户端显示则依然没有数据。
 2：如果有网，消息到达消息中转服务器时，如果一切正常，服务器会返回给10001成功的消息，并创建一条ownerImid为10001，senderImid也为10001的消息发送给10002，注意理解!
 这时候10001客户端显示和10002所有消息时从数据库中获取ownerImid为10002的即可，只有一条；10002客户端显示和10001所有消息时从数据库中获取ownerImid为10001的即可，也会有一条。
 3：这时候我们再考虑10002主动发消息的情况，按照上面的逻辑，成功的话双方都会有两条消息。
 */
@interface IMChatMesssage : RLMObject

#pragma mark -- 必需属性
/**主键，一般取时间戳毫秒，和服务器IMMsgContent的msg_id对应 用作Timeline逻辑模型中的顺序ID 拉取离线就靠这个*/
@property (nonatomic, assign) int64_t msg_id;
/**消息发送状态 发送中、已发送、失败*/
@property (nonatomic, assign) E_CHAT_SEND_STATUS status;
/**消息时间，发送消息时可以不关心这个字段，由server填充，如果是接收方，则是收到该消息的时间，单位秒 */
@property (nonatomic, assign) int64_t time;
/**是否在界面上显示当前消息的时间 当这条消息和上一条相差6分钟时设置为YES 从数据库中读取的时候实时的判断*/
@property (nonatomic, assign) BOOL show_time;
/**发送者*/
@property (nonatomic, strong) IMChater *sender;
/**接收者*/
@property (nonatomic, strong) IMChater *reciver;
/**消息内容*/
@property (nonatomic, strong) IMChatMessageContent *content;

@end
