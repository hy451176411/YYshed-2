//
//  SBAppMessage.h
//  Emtpy
//
//  Created by xiexianhui on 14-7-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBAppMessage : NSObject

//设备信息
//系统名
+ (NSString *)appSystemName;

//系统版本号
+ (NSString *)appSystemVersion;

//设备名称
+ (NSString *)appDeviceName;

//本地模式
+ (NSString *)appLocalizedModel;

+ (NSString*)sbhDeviceUUID;

//获取app信息
//app名称
+ (NSString *)appName;

//app版本
+ (NSString *)appVersion;

//appBuild版本
+ (NSString *)appBuildVersion;

@end
