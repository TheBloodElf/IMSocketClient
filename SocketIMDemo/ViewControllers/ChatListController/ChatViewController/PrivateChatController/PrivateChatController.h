//
//  PrivateChatController.h
//  SocketIMDemo
//
//  Created by Mac on 2018/3/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 单聊界面
 */
@interface PrivateChatController : UIViewController

/**
 通过uid初始化聊天界面

 @param targetId 对方的uid
 @return instancetype
 */
- (instancetype)initWithTargetId:(int)targetId;

@end
