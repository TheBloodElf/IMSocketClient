//
//  NSDate+Format.h
//  business
//
//  Created by C.Maverick on 15/6/7.
//  Copyright (c) 2015年 C.Maverick. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -

#define SECOND	(1)
#define MINUTE	(60 * SECOND)
#define HOUR	(60 * MINUTE)
#define DAY		(24 * HOUR)
#define MONTH	(30 * DAY)
#define YEAR	(12 * MONTH)

#pragma mark -

@interface NSDate (Format)
//时间格式化
@property (nonatomic, readonly) NSInteger	year;
@property (nonatomic, readonly) NSInteger	month;
@property (nonatomic, readonly) NSInteger	day;
@property (nonatomic, readonly) NSInteger	hour;
@property (nonatomic, readonly) NSInteger	minute;
@property (nonatomic, readonly) NSInteger	second;
@property (nonatomic, readonly) NSInteger	weekday;
//算出今天凌晨时间
- (NSDate*)firstTime;
//算出明天凌晨时间
- (NSDate*)lastTime;
//"yyyy-MM-dd HH:mm:ss"格式转换成时间
+ (NSDate*)dateWithFormat:(NSString *)format;

/**
 自己和参与比较的时间相差多少秒

 @param date 比较时间
 @return 两个时间相差的秒数，目标时间大于比较时间返回正数，反之亦然
 */
- (NSTimeInterval)differTimeIntervalToDate:(NSDate*)date;
//今天是周几
- (NSString*)weekdayStr;
//节气字符串
- (NSString*)specialString;
//农历初几
- (NSString*)lunarString;
//农历节假日
- (NSString*)lunarHolidayString;
//公历节假日
- (NSString*)solarHolidayString;
//该天是否为法定放假日
- (BOOL)isLegalHoliday;
//该天是否为法定上班日
- (BOOL)isLegalWorkday;

@end
