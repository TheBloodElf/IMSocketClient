//
//  User.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 应用体系中的用户
 */
@interface User : RLMObject

/**uid*/
@property (nonatomic, readwrite, assign) int uid;
/**昵称*/
@property (nonatomic, readwrite,   copy) NSString *nick;
/**头像*/
@property (nonatomic, readwrite,   copy) NSString *avatar;

/**
 传入指定参数创建用户

 @param uid 用户编号
 @param nick 昵称
 @param avatar 头像
 @return 用户
 */
- (instancetype)initWithUid:(int)uid nick:(NSString*)nick avatar:(NSString*)avatar;

@end
