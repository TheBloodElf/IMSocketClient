//
//  IMSocketListener.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketListener.h"

@implementation HandlerObject

@end

@implementation IMSocketListener

- (void)addEventListener:(NSString *)type withFunction:(CallBackBlock)call {
    if(call == nil) {
        return;
    }
    //初始化观察者字典
    self.observers = self.observers ?: [@{} mutableCopy];
    //得到该类型的消息有没有监听者
    NSMutableArray * funs = [self.observers objectForKey:type] ?: [@[] mutableCopy];
    [self.observers setObject:funs forKey:type];
    //添加一个该消息类型监听者
    HandlerObject *evt = [[HandlerObject alloc] init];
    evt.handler = call;
    [funs addObject:evt];
}

- (void)removeEventListner:(NSString *)type withFunction:(CallBackBlock)call {
    NSMutableArray *funs = [self.observers objectForKey:type];
    if(funs == nil) {
        return;
    }
    HandlerObject *removeHandler = nil;
    for (HandlerObject *e in funs)
        if (e.handler == call) {
            removeHandler = e;
            break;
        }
    if (removeHandler) {
        [funs removeObject:removeHandler];
    }
    if ([funs count] <= 0) {
        [self.observers removeObjectForKey:type];
    }
}

- (void)dispach:(NSString *)type withAgent:(IMSocketRespAgent *)agent {
    NSArray *funs = [self.observers valueForKey:type];
    if(funs == nil) {
        return;
    }
    if(funs.count == 0) {
        return;
    }
    for (HandlerObject *handler in funs) {
        handler.handler(agent);
    }
}

@end
