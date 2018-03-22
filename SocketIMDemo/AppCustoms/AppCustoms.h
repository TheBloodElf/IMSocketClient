//
//  AppCustoms.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 应用全局配置，比如UI颜色等
 */
@interface AppCustoms : NSObject

/**
 获取AppCustoms单例对象

 @return AppCustoms单例对象
 */
+ (AppCustoms *)customs;

@end
