//
//  AppDelegate.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-18.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RootViewController.h"

#import "Reachability.h"
#import "YYshedLoginController.h"

@implementation AppDelegate

#pragma mark 返回xib名称
+ (NSString *)strCtrlName:(NSString *)className
{
    NSString *strCtrlName = DevicePhone ? @"_iPhone" : @"_iPad";
	//
    NSString *nameClass = [[NSString alloc] initWithFormat:@"%@%@",className,strCtrlName];
    return nameClass;
}

+ (AppDelegate *)getAppDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (UINavigationController *)getNav
{
    AppDelegate *appDelegate = [AppDelegate getAppDelegate];
    return appDelegate.nav;
}

#pragma mark 是否有网络
+ (BOOL)isNotReachable
{
    BOOL isExistenceNetwork = YES;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            //   NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            //   NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            //  NSLog(@"正在使用wifi网络");
            break;
    }
    return isExistenceNetwork;
}

- (void)openApp:(NSURL *)url
{
    NSString *tHost = [[url host] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [tHost componentsSeparatedByString:@"&"];
    NSArray *arrUser = [arr[0] componentsSeparatedByString:@"="];
    NSArray *arrPass= [arr[1] componentsSeparatedByString:@"="];
    self.strUser = [arrUser lastObject];
    self.strPass = [arrPass lastObject];
    
    if (self.strUser.length == 0 || self.strPass.length == 0) {
        return;
    }
    
    if (!self.isSuccess) {//未登录
        
        [[AppDelegate getAppDelegate].loginCtrlShare gologinWithUser:_strUser pass:_strPass];
    }
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self openApp:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [self openApp:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [[YYshedLoginController alloc] init];
	self.window.backgroundColor = [UIColor whiteColor];
	self.strIp = @"http://182.92.67.74";
	[self.window makeKeyAndVisible];
	return YES;
	
/*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
//    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"configFile" ofType:@"txt"];
//    NSString *strJson = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"GGG:%@",strJson);
//    NSArray *arr = [strJson componentsSeparatedByString:@","];
//    NSLog(@"arr:%@",arr);
    
//    NSString *strIsDomain = [UserDefaults objectForKey:@"isJava"];
//    if (strIsDomain.length == 0) {
        //设置默认模式  1是java   0是domino
    [UserDefaults setObject:@"1" forKey:@"isJava"];
    [UserDefaults synchronize];
    //    }
    
    isPop = NO;
    self.strTitleApp = @"深圳局移动办公系统";
    
    self.strIp = @"http://gjet.szciqic.net:8090";//@"http://10.21.0.8";
    self.strMailIP = @"http://gjet.szciqic.net:8090";//@"http://10.21.0.145";
    self.strUrl = @"/terminal/api/interface.jsp?appid=22000022&appsecret=abcd1234&";
    
//    NSDictionary *dic = [UserDefaults objectForKey:kOAAddressDic];
//    if (dic) {//已经选择过
//        self.strTitleApp = [NSString stringWithFormat:@"%@局移动办公系统",dic[@"name"]];
//        self.strIp = dic[@"oa_ip"];
//        self.strEmail = dic[@"email_ip"];
//        self.strUrl = dic[@"urlface"];
//        BOOL type = [dic[@"type"] boolValue];
//        if (type) {
//            [UserDefaults setObject:@"1" forKey:@"isJava"];
//        } else  {
//            [UserDefaults setObject:@"0" forKey:@"isJava"];
//        }
//        [UserDefaults synchronize];
//    } else {//没有选择
//        
//    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.strOA = [NSString stringWithFormat:@"%@%@",self.strIp,self.strUrl];
    self.strEmail = [NSString stringWithFormat:@"%@%@",self.strMailIP,self.strUrl];
   
    BOOL isAutoLogin = [UserDefaults boolForKey:kAutoLogin];
    self.isAutoLogin = isAutoLogin;
    
    NSString *strCtrlName = [AppDelegate strCtrlName:@"RootViewController"];
    RootViewController *loginCtrl = [[RootViewController alloc] initWithNibName:strCtrlName bundle:nil];
    self.nav = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    self.window.rootViewController = self.nav;
    self.nav.navigationBarHidden = YES;
    
    [self.window makeKeyAndVisible];
    return YES;*/
	
}

+ (BOOL)isPop3 {
    return NO;
}

- (void)logout {
    [AppDelegate getAppDelegate].isSuccess = NO;
    [AppDelegate getAppDelegate].isAutoLogin = NO;
    self.nav = nil;
    self.window.rootViewController = nil;
    
    NSString *strCtrlName = [AppDelegate strCtrlName:@"RootViewController"];
    RootViewController *loginCtrl = [[RootViewController alloc] initWithNibName:strCtrlName bundle:nil];
    self.nav = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    self.window.rootViewController = self.nav;
    self.nav.navigationBarHidden = YES;
}

#pragma mark 获取用户ID
+ (NSString *)getUserId {
    NSDictionary *dic = [SaveData getMessageKey:kUserMessage];
    return dic[@"userid"];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
