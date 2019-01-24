//
//  IMSocketHeader.m
//  SocketIMDemo
//
//  Created by 李勇 on 18/3/15.
//  Copyright (c) 2018年李勇. All rights reserved.
//

#import "IMSocketHeader.h"

/**包头部的每个内容占用多少字节*/
#define DF_PROPERTY_DATA_LEN   4

@implementation IMSocketHeader

#pragma mark - init

- (instancetype)init {
    if(!self) {
        return nil;
    }
    
    _version = DF_SOCKET_HEADER_VERSION;
    _magic_num = DF_SOCKET_HEADER_MAGIC_NUM;
    return self;
}

#pragma mark -- Init Methods

#pragma mark -- Function Methods

/**
 将int转换为byte数组
 
 @param a int数据
 @param aResult 放到哪个byte数组中
 @return byte数组
 */
unsigned char* intTobytes(int a,unsigned char* aResult) {
    unsigned char * result = aResult;
    result[3] = (unsigned char)(a &0xff);
    result[2] = (unsigned char)(a >> 8 &0xff);
    result[1] = (unsigned char)(a >> 16 &0xff);
    result[0] = (unsigned char)(a >> 24 &0xff);
    return result;
}

/**
 bytes转成成int
 
 @param aDes 需要转换的bytes
 @return int结果
 */
int bytesToint(unsigned char* aDes) {
    int result;
    result = (aDes[0] & 0xff) << 24
    | (aDes[1] & 0xff) << 16
    | (aDes[2] & 0xff) << 8
    | (aDes[3] & 0xff) << 0;
    return result;
}

#pragma mark - Pravite methods

#pragma mark - Public methods

- (NSData *)getHeaderData {
    NSMutableData *header_data = [NSMutableData data];
    Byte resultByte[4] ={0};
    [header_data appendBytes:intTobytes(_version, resultByte) length:DF_PROPERTY_DATA_LEN];
    [header_data appendBytes:intTobytes(_magic_num, resultByte) length:DF_PROPERTY_DATA_LEN];
    [header_data appendBytes:intTobytes(_command, resultByte) length:DF_PROPERTY_DATA_LEN];
    [header_data appendBytes:intTobytes(_body_len, resultByte) length:DF_PROPERTY_DATA_LEN];
    return header_data;
}

- (void)setProperty:(NSData *)data {
    int offset = 0;
    _version = bytesToint((void *)[[data subdataWithRange:NSMakeRange(offset, DF_PROPERTY_DATA_LEN)] bytes]);
    offset += DF_PROPERTY_DATA_LEN;
    _magic_num = bytesToint((void *)[[data subdataWithRange:NSMakeRange(offset, DF_PROPERTY_DATA_LEN)] bytes]);
    offset += DF_PROPERTY_DATA_LEN;
    _command = bytesToint((void *)[[data subdataWithRange:NSMakeRange(offset, DF_PROPERTY_DATA_LEN)] bytes]);
    offset += DF_PROPERTY_DATA_LEN;
    _body_len = bytesToint((void *)[[data subdataWithRange:NSMakeRange(offset, DF_PROPERTY_DATA_LEN)] bytes]);
    offset += DF_PROPERTY_DATA_LEN;
}

@end

