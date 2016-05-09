//
//  SBHPublicDate.m
//
//  Created by xie xianhui on 13-6-23.
//  Copyright (c) 2013年 xie xianhui. All rights reserved.
//

#import "SBHPublicDate.h"

@implementation SBHPublicDate

#pragma mark 时间戳转换成时间字符串   时间戳  秒
+ (NSString *)sbhStrTimeSConversion:(NSString*)timestamp timeType:(NSString*)timestr
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:([timestamp doubleValue])];
    __autoreleasing NSString *time = [[NSString alloc] initWithString:[SBHPublicDate stringFromDate:date timeType:timestr]];
    return time;
}

//时间戳转换时间字符串　　　时间格式@"yyyy-MM-dd HH:mm:ss"   毫秒
+ (NSString *)sbhStrTimeMSConversion:(NSString*)timestamp
                            timeType:(NSString*)timestr
{
    NSTimeInterval timesMiao = [timestamp doubleValue]/1000;
    timesMiao += (60 * 60 * 8);
    
    timestamp = [NSString stringWithFormat:@"%f",timesMiao];
    

    __autoreleasing NSString *time = [[NSString alloc] initWithString:[SBHPublicDate sbhStrTimeSConversion:timestamp timeType:timestr]];
    return time;
}

#pragma mark 时间字符串转换成时间戳  时间格式@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)stringConversionWithDateString:(NSString *)theStrDate timeType:(NSString *)theStrTime
{
    NSDate *tmpDate = [self dateFromString:theStrDate timeType:theStrTime];
    long int tmpTime = (long)[tmpDate timeIntervalSince1970];
    tmpTime -= (60 * 60 * 8);
    NSString *tmpStrConversion = [NSString stringWithFormat:@"%ld",tmpTime];
    return tmpStrConversion;
}

#pragma mark 时间Date转换成时间戳  时间格式@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)stringConversionWithDate:(NSDate *)theDate timeType:(NSString *)theStrTime
{
    long int tmpTime = (long)[theDate timeIntervalSince1970];
    tmpTime -= (60 * 60 * 8);
    NSString *tmpStrConversion = [NSString stringWithFormat:@"%ld",tmpTime];
    return tmpStrConversion;
}

#pragma mark 获取年月日时分秒周几
+ (NSDictionary *)getYearMonthDayHourMinuteSecondWeek:(NSDate *) date
{
    __autoreleasing NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    __autoreleasing NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //年
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger year = [comps year];
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
    [tmpDic setObject:[NSNumber numberWithInteger:year] forKey:@"year"];
    //月
    unitFlags = NSMonthCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger month = [comps month];
    [tmpDic setObject:[NSNumber numberWithInteger:month] forKey:@"month"];
    //日
    unitFlags = NSDayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger day = [comps day];
    [tmpDic setObject:[NSNumber numberWithInteger:day] forKey:@"day"];
    //时
    unitFlags = NSHourCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [comps hour];
    [tmpDic setObject:[NSNumber numberWithInteger:hour] forKey:@"hour"];
    //分
    unitFlags = NSMinuteCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [comps minute];
    [tmpDic setObject:[NSNumber numberWithInteger:minute] forKey:@"minute"];
    //秒
    unitFlags = NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger second = [comps second];
    [tmpDic setObject:[NSNumber numberWithInteger:second] forKey:@"second"];
    //周几
    unitFlags = NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger weekday = [comps weekday];
    [tmpDic setObject:[NSNumber numberWithInteger:weekday] forKey:@"weekday"];
    return tmpDic;
}

#pragma mark 将NSString日期转成NSDate  时间格式@"yyyy-MM-dd HH:mm:ss" 注：四个大Y会少一年
/*
 dateString的时间格式要跟timestr一致
 */
+ (NSDate *)dateFromString:(NSString *)dateString timeType:(NSString*)timestr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:timestr];
    __autoreleasing NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

#pragma mark 将NSDate日期转成NSString
/*
 将date的时间格式转换成timestr格式的时间字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date timeType:(NSString*)timestr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:timestr];
    __autoreleasing NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark 计算两个日期相差多少天
+ (NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate {
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSInteger startDay=[cal ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[cal ordinalityOfUnit:NSDayCalendarUnit inUnit: NSEraCalendarUnit forDate:endDate];
    return endDay-startDay;
}

#pragma mark 某天是否在当前一周内
+ (BOOL)boolDateThisWeek:(NSDate *)date betweenDay:(NSInteger)day{
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    NSDateComponents *weekdayComponents = [cal components:NSWeekdayCalendarUnit fromDate:today];
    NSInteger week = [weekdayComponents weekday];
    NSInteger num = 7;
    if (week>1 && week<=7) {
        num = week-1;
    }
    if (day>0&&day<num) {
        num -=day;
        return YES;
    }
    return NO;
}

#pragma mark 根据日期返回星期几
+ (NSString *)stringWithWeek:(NSDate *)d
{
    __autoreleasing NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags
                                               fromDate:d];
    switch ([components weekday]) {
        case 2:
            return @"周一"; break;
        case 3:
            return @"周二"; break;
        case 4:
            return @"周三"; break;
        case 5:
            return @"周四"; break;
        case 6:
            return @"周五"; break;
        case 7:
            return @"周六"; break;
        case 1:
            return @"周日"; break;
        default:
            return @"NO Week"; break;
    }
}

#pragma mark 当前系统时间　解决相差８小时问题  ([NSDate date]会少8小时)
+ (NSDate *)dateWithDate:(NSDate*)date
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

#pragma mark NSDate转成农历函数
+ (NSString *)stringLunarWithSolarDate:(NSDate *)solarDate{
    //天干名称
    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
    
    //地支名称
    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    
    //属相名称
    NSArray *cShuXiang = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static NSInteger wCurYear,wCurMonth,wCurDay;
    static NSInteger nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];//时间相差8小时
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i = 1;i < n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) % 12]];
    
    //生成农历月、日
    NSString *szNongliDay;
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];
    
    return lunarDate;
}

#pragma mark 获取本地时间包含时区
+ (NSString *)stringLocalDate
{
    __autoreleasing NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    __autoreleasing  NSString *dateString = [[NSString alloc] initWithString:[dateFormatter stringFromDate:[NSDate date]]];

    return dateString;
}

#pragma mark 计算两个时间之间相差的时间戳值
+ (double)timeIntervalWithinEraStartDate:(NSDate *) startDate endDate:(NSDate *) endDate
{
    double start = [startDate timeIntervalSince1970];
    double end = [endDate timeIntervalSince1970];
    start -= (60 * 60 * 8);
    end -= (60 * 60 * 8);
    return end-start;
}

#pragma mark 计算时间
+ (NSString *)strWithCurrentTime:(NSString *)strDate andType:(NSInteger)types
{
    __autoreleasing NSMutableString *muStr = [[NSMutableString alloc] init];
    NSDate *date = [self dateFromString:strDate timeType:@"yyyy-MM-dd H:m:s"];
    NSDate *currentDate = [NSDate date];
    
    double time = [self timeIntervalWithinEraStartDate:date endDate:currentDate];
    
    CGFloat dayTime = 60*60*24;
    CGFloat hourTime = 60*60;
    
//    NSArray *arr = [strDate componentsSeparatedByString:@":"];
//    [muStr appendFormat:@"%@%@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
//    
//    
//    return strDate;
    
//    if (types == 1) {//不需要计算到分钟
//        NSArray *arr = [strDate componentsSeparatedByString:@" "];
//        [muStr appendString:[arr objectAtIndex:0]];
//    } else {
        if (time > dayTime * 3) {//超过3天
            NSArray *arr = [strDate componentsSeparatedByString:@" "];
            if (arr) {
                [muStr appendString:[arr objectAtIndex:0]];
            }
        } else if (time > dayTime){//超过24小时
            if (time < 2*dayTime) {//昨天
                [muStr appendString:@"昨天"];
            } else {
                [muStr appendString:@"前天"];
            }
        } else {//
            if (time < hourTime) {//不超过1小时
                if (time < 60) {//1分钟内
                    [muStr appendString:@"1分钟前"];
                } else {
                    NSInteger timeInt = time/60;
                    [muStr appendFormat:@"%ld分钟前",(long)timeInt];
                }
                //            [muStr appendString:@"1小时前"];
            } else {
                NSInteger hour = time/hourTime;
                [muStr appendFormat:@"%ld小时前",(long)hour];
            }
        }
//    }
    return muStr;
}

//传入时间戳
+ (NSString *)strWithCurrentTimeConversion:(NSString *)strConversion
{
    __autoreleasing NSMutableString *muStr = [[NSMutableString alloc] init];
    NSTimeInterval timeInterval = [strConversion doubleValue]/1000;
    timeInterval = 1420700490;
    NSDate *currentDate = [NSDate date];
    NSTimeInterval currentTimeInterval = currentDate.timeIntervalSince1970;
    
    NSTimeInterval betweenTimeInterval = currentTimeInterval - timeInterval;
    
    CGFloat dayTime = 60*60*24;
    CGFloat hourTime = 60*60;
    
    if (betweenTimeInterval < 10) {//刚刚
        [muStr appendString:@"刚刚"];
    } else if (betweenTimeInterval < 60) {//多少秒之前
        [muStr appendFormat:@"%.0f秒前",betweenTimeInterval];
    } else if (betweenTimeInterval < hourTime) {//多少分钟之前
        [muStr appendFormat:@"%.0f分钟前",(betweenTimeInterval/60)];
    } else if (betweenTimeInterval < dayTime) {//多少小时前
        [muStr appendFormat:@"%.0f小时前",(betweenTimeInterval/hourTime)];
    } else if (betweenTimeInterval < (dayTime * 3)) {//3天前
        [muStr appendFormat:@"%.0f天前",(betweenTimeInterval/dayTime)];
    } else {
        [muStr appendString:[SBHPublicDate sbhStrTimeMSConversion:strConversion timeType:@"yyyy-M-d H:m"]];
    }
    return muStr;
}

@end
