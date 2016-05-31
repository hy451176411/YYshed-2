//
//  AppDelegate.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-18.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL isPop;

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) NSString *strOA;
@property (nonatomic, strong) NSString *strEmail;
@property (nonatomic, strong) NSString *strIp;
@property (nonatomic, strong) NSString *strUrl;
@property (nonatomic, strong) NSString *strMailIP;

@property (nonatomic, retain) NSArray *arrModule;//模块数据
@property (nonatomic, assign) BOOL isSuccess;//是否登录
@property (nonatomic, assign) BOOL isAutoLogin;//是否自动登录
@property (nonatomic, retain) NSString *strUser;//用户名
@property (nonatomic, retain) NSString *strPass;//密码
@property (nonatomic, retain) NSString *strTitleApp;//app的标题

//退出
- (void)logout;

+ (UINavigationController *)getNav;
+ (AppDelegate *)getAppDelegate;
//返回xib名称
+ (NSString *)strCtrlName:(NSString *)className;
//是否使用pop3
+ (BOOL)isPop3;

+ (NSString *)getUserId;
//获取是否有网
+ (BOOL)isNotReachable;
@end
