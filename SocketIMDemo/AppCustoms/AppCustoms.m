//
//  AppCustoms.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "AppCustoms.h"

/**AppCustoms单例对象*/
static AppCustoms * APP_CUSTOMS_SINGLETON;

@implementation AppCustoms

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Public Methods

+ (AppCustoms *)customs {
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{ APP_CUSTOMS_SINGLETON = [[[self class] alloc] init]; } );
    return APP_CUSTOMS_SINGLETON;
}

@end
