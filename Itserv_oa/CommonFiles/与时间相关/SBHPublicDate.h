//
//  SBHPublicDate.h
/**
 version:1.0
 NSDate跟字符串之间的转换
 时间字符串跟时间戳之间的转换
 NSDate转换成农历
 */
//  Created by xie xianhui on 13-6-23.
//  Copyright (c) 2013年 xie xianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBHPublicDate : NSObject

//-----------------时间
//时间戳转换时间字符串　　　时间格式@"yyyy-MM-dd HH:mm:ss"   秒
+ (NSString *)sbhStrTimeSConversion:(NSString*)timestamp
                   timeType:(NSString*)timestr;

//时间戳转换时间字符串　　　时间格式@"yyyy-MM-dd HH:mm:ss"   毫秒
+ (NSString *)sbhStrTimeMSConversion:(NSString*)timestamp
                           timeType:(NSString*)timestr;


//时间字符串转换成时间戳  时间格式@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)stringConversionWithDateString:(NSString *)theStrDate timeType:(NSString *)theStrTime;
+ (NSString *)stringConversionWithDate:(NSDate *)theDate timeType:(NSString *)theStrTime;

//获取年月日时分秒周几
+ (NSDictionary *)getYearMonthDayHourMinuteSecondWeek:(NSDate *) date;

//将NSString日期转成NSDate  时间格式@"yyyy-MM-dd HH:mm:ss" 注：四个小Y会少一年
+ (NSDate *)dateFromString:(NSString *)dateString
                  timeType:(NSString*)timestr;

//将NSDate日期转成NSString  时间格式@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)stringFromDate:(NSDate *)date
                    timeType:(NSString*)timestr;

//计算两个日期相差多少天
+ (NSInteger)daysWithinEraFromDate:(NSDate *)startDate
                            toDate:(NSDate *) endDate;

//某天是否在当前一周内
+ (BOOL)boolDateThisWeek:(NSDate *)date betweenDay:(NSInteger)day;

//根据日期返回星期几
+ (NSString *)stringWithWeek:(NSDate *)d;

//当前系统时间　解决相差８小时问题  ([NSDate date]会少8小时)
+ (NSDate *)dateWithDate:(NSDate*)date;

//NSDate转成农历函数
+ (NSString *)stringLunarWithSolarDate:(NSDate *)solarDate;

//获取本地时间包含时区
+ (NSString *)stringLocalDate;

//计算两个时间之间相差的时间戳值
+ (double)timeIntervalWithinEraStartDate:(NSDate *) startDate endDate:(NSDate *) endDate;

//计算时间，刚刚，1分钟前  strDate字符串时间
+ (NSString *)strWithCurrentTime:(NSString *)strDate andType:(NSInteger)types;

//传入时间戳
+ (NSString *)strWithCurrentTimeConversion:(NSString *)strConversion;
@end
