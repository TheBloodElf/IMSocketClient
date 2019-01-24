//
//  NSObject+data.h
//  BangBang
//
//  Created by lottak_mac2 on 16/5/20.
//  Copyright © 2016年 Lottak. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 给所有对象添加data运行时属性
 */
@interface NSObject (CMData)

@property (nonatomic, strong) id data;

- (void)dataWillChange;

- (void)dataDidChange;

@end
