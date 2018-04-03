//
//  YJNChatBarProtocol.h
//  SocketIMDemo
//
//  Created by YangJing on 2018/4/3.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YJNChatBarProtocol <NSObject>
-(void)yjn_sendMsgButtonTouched:(NSString *)message;
@end
