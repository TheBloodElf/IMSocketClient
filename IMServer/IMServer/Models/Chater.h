//
//  Chater.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

/**
 聊天体系中的用户
 */
@interface Chater : RLMObject

/**唯一标识符，和用户体系uid一样*/
@property (nonatomic, assign) int64_t imid;
/**昵称*/
@property (nonatomic, strong) NSString *nick;
/**头像地址*/
@property (nonatomic, strong) NSString *avatar;

@end

