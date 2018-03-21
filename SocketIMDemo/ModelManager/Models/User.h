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
@property (nonatomic, assign) int uid;
/**昵称*/
@property (nonatomic, strong) NSString *nick;
/**头像*/
@property (nonatomic, strong) NSString *avatar;


@end
