//
//  UIColor+FlatUI.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

@interface UIColor (FlatUI)

/**
 用16进制字符串构造UIColor对象

 @param hexString 3位或者6位16进制字符串，可以不加#
 @return UIColor对象
 */
+ (UIColor *)colorFromHexCode:(NSString *)hexString;

@end
