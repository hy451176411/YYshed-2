//
//  SBAppMessage.m
//  Emtpy
//
//  Created by xiexianhui on 14-7-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "SBAppMessage.h"

@implementation SBAppMessage

#pragma mark 设备信息
#pragma mark 系统名
+ (NSString *)appSystemName
{
    return [[UIDevice currentDevice] systemName];
}

//系统版本号
+ (NSString *)appSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//设备名称
+ (NSString *)appDeviceName
{
    return [[UIDevice currentDevice] name];
}

//本地模式
+ (NSString *)appLocalizedModel
{
    return [[UIDevice currentDevice] localizedModel];
}

+ (NSString*)sbhDeviceUUID {
    
    NSString *strVersion = [SBAppMessage appSystemVersion];
    CGFloat version = strVersion.floatValue;
    if (version >= 6.0) {
        NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
        NSString *strUUID = uuid.UUIDString;
        return strUUID;
    }
    
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    CFStringRef resultStr = CFStringCreateCopy( NULL, uuidString);
    
    NSString * result =  (NSString *)CFBridgingRelease(resultStr);
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

#pragma mark 获取app信息
//app名称
+ (NSString *)appName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
}

//app版本
+ (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

//appBuild版本
+ (NSString *)appBuildVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build;
}

@end
