//
//  IMSocketReqContext.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketReqContext.h"

@implementation IMSocketReqContext

-(instancetype)init {
    self = [super init];
    if(!self) {
        return nil;
    }
    
    _res = 0;
    return self;
}

@end
