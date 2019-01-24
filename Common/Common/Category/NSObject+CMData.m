//
//  NSObject+data.m
//  BangBang
//
//  Created by lottak_mac2 on 16/5/20.
//  Copyright © 2016年 Lottak. All rights reserved.
//

#import "NSObject+CMData.h"

static const char kUIViewDataKey;

@implementation NSObject (CMData)

@dynamic data;

- (void)setData:(id)data {
    [self dataWillChange];
    objc_setAssociatedObject(self, &kUIViewDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self dataDidChange];
}

- (id)data {
    return objc_getAssociatedObject(self, &kUIViewDataKey);
}

- (void)dataWillChange {
    // to implement
}

- (void)dataDidChange {
    // to implement
}

@end
