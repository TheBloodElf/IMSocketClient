//
//  User.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "User.h"

@implementation User

MJExtensionCodingImplementation

- (instancetype)initWithUid:(int)uid nick:(NSString*)nick avatar:(NSString*)avatar {
    self = [super init];
    if(!self) {
        return nil;
    }
    
    _uid = uid;
    _nick = nick;
    _avatar = avatar;
    return self;
}

+ (NSString*)primaryKey {
    return @"uid";
}

@end
