//
//  IMClientLog.m
//  IMServer
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "IMClientLog.h"

@implementation IMClientLog

MJExtensionCodingImplementation

#pragma mark -- Init Methods

#pragma mark -- Function Methods

#pragma mark -- Private Methods

+ (NSString*)primaryKey {
    return @"id";
}

#pragma mark -- Public Methods

+ (instancetype)clientLogWithMessage:(NSString*)message {
    IMClientLog *clientLog = [IMClientLog new];
    clientLog.id = [NSDate new].timeIntervalSince1970 * 1000;
    clientLog.message = message;
    clientLog.date = [NSDate new];
    return clientLog;
}

@end
