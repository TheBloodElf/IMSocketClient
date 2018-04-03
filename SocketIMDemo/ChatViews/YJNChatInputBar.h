//
//  YJNChatInputBar.h
//  SocketIMDemo
//
//  Created by Vanduza on 2018/3/27.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJNChatBarProtocol.h"

@interface YJNChatInputBar : UIView
@property (nonatomic, assign) CGFloat verticalPadding UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat horizontalPadding UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat inputViewMinHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat inputViewMaxHeight UI_APPEARANCE_SELECTOR;

@property (nonatomic, weak) id <YJNChatBarProtocol> delegate;

+ (CGFloat)defaultHeight;
@end
