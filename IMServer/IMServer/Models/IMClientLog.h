//
//  IMClientLog.h
//  IMServer
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 客户端日志，用来显示记录
 */
@interface IMClientLog : RLMObject

/**唯一标识符*/
@property (nonatomic, assign) int64_t id;
/**时间*/
@property (nonatomic, strong) NSDate *date;
/**日志内容*/
@property (nonatomic, strong) NSString *message;

/**
 通过内容快速创建IMClientLog对象

 @param message 日志内容
 @return IMClientLog对象
 */
+ (instancetype)clientLogWithMessage:(NSString*)message;

@end
