//
//  IMChatMessageContent.h
//  IMServer
//
//  Created by Mac on 2018/3/26.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 消息内容
 */
@interface IMChatMessageContent : RLMObject

/**消息类型*/
@property (nonatomic, assign) CHAT_CONTENT_TYPE type;

/**类型为文本时 文本内容*/
@property (nonatomic, strong) NSString *text;

@end
