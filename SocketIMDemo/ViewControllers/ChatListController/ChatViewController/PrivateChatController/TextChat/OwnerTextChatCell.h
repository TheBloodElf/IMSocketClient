//
//  OwnerTextChatCell.h
//  SocketIMDemo
//
//  Created by Mac on 2019/1/25.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatMessageDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 文本消息，自己发送的
 */
@interface OwnerTextChatCell : UITableViewCell

/**消息代理*/
@property (nonatomic, weak) id<ChatMessageDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
