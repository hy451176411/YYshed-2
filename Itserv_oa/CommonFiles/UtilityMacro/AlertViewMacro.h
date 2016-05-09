//
//  AlertViewMacro.h
//  CBExtension
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#ifndef ProjectStructure_AlertViewMacro_h
#define ProjectStructure_AlertViewMacro_h

#define LoginAlertTag 7654321


//展示一般的警告信息
#define ShowAlertQuick(msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];\
[alert show];\
[alert release];

//展示一般的提示信息，不设标题，不设置委托，只有一个按钮
#define ShowAlertQuickNOTitle(msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];\
[alert show];\
[alert release];


//展示一般的警告信息,加代理
#define ShowAlert1(msg,del) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:msg delegate:del cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];\
[alert show];\
[alert release];


//展示一般的提示信息，不设置委托，只有一个按钮
#define ShowAlert2(title,msg,disBtnTitle)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:disBtnTitle, nil];\
[alert show];\
[alert release];

//展示提示信息
#define ShowAlert3(title,msg,delegate)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];\
alert.delegate = delegate;\
[alert show];\
[alert release];

#define ShowAlert4(title,msg,disBtnTitle,OKBtnTitle,del)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:disBtnTitle otherButtonTitles:OKBtnTitle, nil];\
[alert show];\
[alert release];

#define ShowAlert5(title,msg,disBtnTitle,OKBtnTitle,del,tag)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:disBtnTitle otherButtonTitles:OKBtnTitle, nil];\
alert.tag = tag;\
[alert show];\
[alert release];

//session过期提示
#define ShowAlertSessionOutOfDate(del)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"你还没有登录或已经在其它地方登录了,要继续操作请登录" delegate:del cancelButtonTitle:@"知道了" otherButtonTitles:@"马上登录", nil];\
alert.tag = LoginAlertTag;\
[alert show];\
[alert release];

//账号没有登录
#define ShowAlertLogin(del)\
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"你还没有登录,要继续操作请登录" delegate:del cancelButtonTitle:@"知道了" otherButtonTitles:@"马上登录", nil];\
alert.delegate = delegate;\
alert.tag = LoginAlertTag;\
[alert show];\
[alert release];

//显示网络请求出错警告
#define ShowAlertNetworkError(error) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络请求出错提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];\
[alert show];\
[alert release];


//展示一般的警告信息
#define ShowAlertHUD(message) \
MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:GB_Nav.view];\
[GB_Nav.view addSubview:HUD];\
HUD.mode = MBProgressHUDModeText;\
HUD.detailsLabelText = message;\
HUD.yOffset = -15.0f;\
[HUD show:YES];\
[HUD hide:YES afterDelay:1.0f];\

#define ShowSuccessHUD(message) \
MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:GB_Nav.view];\
[GB_Nav.view addSubview:HUD];\
HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]] autorelease];\
progressHUD.mode = MBProgressHUDModeCustomView;\
HUD.detailsLabelText = message;\
[HUD show:YES];\
[HUD hide:YES afterDelay:2.0f];\

#define ShowFailureHUD(message) \
MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:GB_Nav.view];\
[GB_Nav.view addSubview:HUD];\
HUD.mode = MBProgressHUDModeText;\
HUD.detailsLabelText = message;\
[HUD show:YES];\
[HUD hide:YES afterDelay:1.0f];\


#endif
