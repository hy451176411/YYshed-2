//
//  EADefine.h
//  网络请求用到的各种常量、宏定义、枚举等
//
//  Created by yufeiyue  on 13-7-9.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

//====================================================
// 用途: 服务器地址
//====================================================i



typedef enum  {
	RequestToken = 100,//获取RequestToken,
	Login,//登录
	YYShed_getUserinfo,
	YYShed_openErelay,
	YYShed_getDeviceInfo,
	YYShed_getAnalysisResult,
	YYShed_getShedStrategy,
	YYShed_devgeogroupInfo,
	YYShed_updateDevAlias,
	YYShed_updateDevComponentAlias,
	YYShed_getColumnList,
	YYShed_getContentList,
	YYShed_getAdversList,
	YYShed_addDevice

} HttpRequestTag;

typedef enum  {
	TAG_REMBER_PSD = 1000,//记住密码
	TAG_REMBER_AUTOLOGIN,//自动登录
} TAG_REMBER;




#define Consumer_key   (@"D9C48AC6-E1B7-4A3D-8C47-EF5B71F65BDC") //consumer_secret：11D9EF03-3443-449D-8190-AA999AC18ED8
#define Consumer_secret (@"11D9EF03-3443-449D-8190-AA999AC18ED8&")
#define Oauth_signature_method	(@"HMAC-SHA1") //生成签名的方式，默认值HMAC-SHA1
#define Oauth_version	(@"1.0") //String	版本号，默认
#define Oauth_callback	(@"http://www.cipnet.cn") //String	回调地址，默认

#define AddController_backgroundColor self.view.backgroundColor=[UIColor colorWithRed:(0xde)/255.0 green:(0xe1)/255.0 blue:(0xe5)/255.0 alpha:(0.0)];
#define Background_RGBACOLOR [UIColor colorWithRed:(0xde)/255.0 green:(0xe1)/255.0 blue:(0xe5)/255.0 alpha:(0.0)]
#define WHETHERTABLEHIDDEN(_TABLE,_IMAGE,_WHETHER,_RESETEDITING){_TABLE.hidden=_WHETHER;_IMAGE.hidden=!_WHETHER;if([_TABLE isKindOfClass:[UITableView class]]){_TABLE.editing=_RESETEDITING?NO:_TABLE.editing;}}

//====================================================
// 用途: 判断字符串是否为空
//====================================================
#define strIsEmpty(str) (str==nil || [str length]<1 ? YES : NO )

//====================================================
#define RGBACOLOR(_r, _g, _b, _a) [UIColor colorWithRed:(_r)/255.0 green:(_g)/255.0 blue:(_b)/255.0 alpha:(_a)]




