//
//  NSString+isBlank.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

@interface NSString (isBlank)

/**
 字符串是否为空
 
 @param str 待检测的字符串
 @return 是否为空字符串
 */
+ (BOOL)isBlank:(NSString*)str;

@end

