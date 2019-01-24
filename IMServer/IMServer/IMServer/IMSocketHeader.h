//
//  IMSocketHeader.h
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

/**发送包头部长度*/
#define DF_SOCKET_HEADER_LENGTH     (16)
/**头部版本号*/
#define DF_SOCKET_HEADER_VERSION    (0x01)
/**校验码*/
#define DF_SOCKET_HEADER_MAGIC_NUM  (0x20140804)

/**
 包头部：版本号+校验码+该包类型+包内容长度
 */
@interface IMSocketHeader : NSObject

/**版本 现固定为0x01*/
@property (nonatomic,assign) int version;
/**校验码*/
@property (nonatomic,assign) int magic_num;
/**包类型*/
@property (nonatomic,assign) E_SOCKET_HEADER_CMD_TYPE command;
/**body长度*/
@property (nonatomic,assign) int body_len;

/**
 获取Header的二进制数据
 
 @return Header的二进制数据
 */
- (NSData *)getHeaderData;

/**
 Set Header的属性值
 
 @param data Header的属性值
 */
- (void)setProperty:(NSData *)data;

@end

