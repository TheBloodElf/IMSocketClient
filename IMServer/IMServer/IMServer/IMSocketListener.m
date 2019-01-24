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

@interface IMSocketListener ()

/**该类型消息来了，会通知哪些观察者 为什么需要这个呢？因为发送消息时你有handler，发送成功后可以通过handler回调，但是接收消息时并不能注册handler，所以就需要注册好勾子并分发出来*/
@property (nonatomic,strong) NSMutableDictionary<NSString*,NSMutableArray<HandlerObject*>*> *observers;

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
