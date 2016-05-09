//
//  CommonDefine.h
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//


//判断是否是ipad
#define kIsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否是ios7
#define kIsIos7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//默认数据库
#define UserDefaults [NSUserDefaults standardUserDefaults]

#define kHiddenAlertTime 2

//记住密码
#define kRememberPwd @"rememberPwd"

//登录的session_token
#define YYSession_token @"session_token"

//自动登录
#define kAutoLogin @"autoLogin"

//用户名
#define kUserName @"username"

//密码
#define kPwd @"pwd"

//用户信息key
#define kUserMessage @"userMessage"


//OA地址
#define kOAIp @"OAIp"

//mail地址
#define kMailIp @"mailIp"

//邮箱是否需要自动绑定
#define kEmailAuto @"mailAuto"

//接口地址
#define kFaceUrl @"faceUrl"

#define kOAAddressDic @"address"

//文件保存地址
#define kSaveFilePath(NAME) [NSString stringWithFormat:@"%@/%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/"],NAME]


typedef enum{
    SendMail = 1,//发送邮件
    ReplyMail,//回复邮件
    ForwardingMail,//转发邮件
    PeopleSendMail,//草稿进入发送邮件
}MailType;
