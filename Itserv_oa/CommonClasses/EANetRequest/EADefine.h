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


#define TESTDOMAIN     @"http://121.199.26.215:8088/weboa/app.nsf/interface?OpenAgent&func=" //内网地址

//内容详情
#define ContentUrl(STR) [NSString stringWithFormat:@"http://121.199.26.215:8088%@",STR]

#define DomainLoginTwo @"http://121.199.26.215:8088/names.nsf?"

#define WebSeviceUrl TESTDOMAIN

#define HttpRequestMethod @"requestCommand"

//请求tag宏定义
#define Http_RequestToken_Tag 100 //获取RequestToken

#define Http_Login_Tag 101 //登陆

#define Http_AccessToken_Tag 102 //获取AccessToken

#define Http_Messages_Tag 103 //定时提醒数据

#define Http_Brands_Tag 104 //品牌列表

#define Http_Categories_Tag 105 //分类列表

#define Http_Productlist_Tag 106 //商品列表(附:筛选)

#define Http_Product_Tag 107 // 商品详情

#define Http_Channelcate_Tag 108 //频道专区主页

#define Http_Channelllist_Tag 109 //频道专区主页

#define Http_Car_Tag 110 //购物车

#define Http_Checkout_Tag 111 //结算中心

#define Http_Check_couponcard_Tag 112 // 验证优惠卷是否有效

#define Http_Submitorder_Tag 113 // 提交订单

#define Http_Addresslist_Tag 114 //  地址列表

#define Http_Favorite_Tag 115 // 收藏夹列表

#define Http_Orders_Tag 116 //订单列表

#define Http_Orderdetail_Tag 117 //订单详情

#define Http_More_Tag 118 //获取我的爱慕页面更多推荐的信息

#define Http_Active_Tag 119 //激活(第一次运行)

#define Http_Version_Tag 120 //版本检查

#define Http_Register_Tag 121 //注册

#define Http_Productionfo_Tag 122 // 更新商品信息

#define Http_Logout_Tag 123 //注销

#define Http_Car_add_Tag 124 //添加到购物车

#define Http_Addsuittocar_Tag 125 //  添加套装到购物车

#define Http_EditCar_Tag 126 //修改购物车

#define Http_Editsuittocar_Tag 127 //修改购物车中的套装

#define Http_Suittocart_deletes_Tag 128 // 删除购物车中的套装

#define Http_Delcar_Tag 129 //从购物车删除

#define Http_Addressadd_Tag 130 //添加地址

#define Http_AddressEdit_Tag 131 //修改地址

#define Http_AddressDel_Tag 132 //删除地址

#define Http_FavoriteAdd_Tag 133 //添加到收藏夹

#define Http_FavoriteDel_Tag 134 //从收藏夹删除

#define Http_CancelOrder_Tag 135 //取消订单

#define Http_NoticeList_Tag 136 //消息列表

#define Http_SuitList_Tag 137 //  套装列表

#define Http_FeedBack_Tag 138 //  意见反馈

typedef enum  {
	RequestToken = 100,//获取RequestToken,
	Login,//登录
	Regist,//注册
	SureLogin,//确认登录
	SureMail,//确认登录
	SubMenuList,//获取子菜单列表
	NeedDealList,//获取待处理列表  待办
	NeedDealListOne,//获取待处理列表  待阅
	NeedDealListCounter,//获取待处理列表  已阅
	NeedDealListDo,//获取待处理列表  已办
	NotifyMsgList,//推送消息
	DocList = 140,//公文
	SendEmail,//发邮件
	EmailContent,//邮件内容
	DeleteMail,//删除邮件
	ContactList,//通讯录
	ContactSearch,//搜索通讯录
	Version,//版本
	Server,//机构
	VerficationCode,//验证码
	MailList = 180,//邮件列表
	ReadFile = 200,//读取文件内容
	DownFile = 210,//下载文件
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

#define APP_STORE_ID @"540979751"

//====================================================
// 用途: API拼接
// 格式: 数据名称_API
//====================================================
#define Login_API        (@"login")              //登录
#define SureLogin_API    (@"login")          //确认登录
#define getSubMenuList (@"getSubMenuList")   //获取子菜单列表
#define getNeedDealList  (@"getNeedDealList")        //获取待处理列表  待办
#define getNeedDealListOne  (@"getNeedDealList")        //获取待处理列表  待办
#define getNotifyMsgList (@"getNotifyMsgList") //获取推送消息列表getNotifyMsgList
#define getDocList (@"getDocList") //获取公文列表getDocList
#define getMailList (@"getMailList") //获取邮件列表getMailList
#define deleteMail (@"deleteMail") //获取删除邮件deleteMail
#define getMail (@"getMail") //获取邮件内容getMail
#define getContactList (@"getContactList")  //获取通讯录
#define getContactSearch (@"getContactList")  //获取搜索
#define getSendMail (@"sendMail")  //获取发送邮件
#define getVersion (@"getAppVer")  //获取版本
#define getServerList (@"getServerList")  //获取机构
#define getVerificationCode (@"getVerificationCode")  //获取pad验证码
#define Regist_API        (@"regist")              //注册


#define Consumer_key   (@"D9C48AC6-E1B7-4A3D-8C47-EF5B71F65BDC") //consumer_secret：11D9EF03-3443-449D-8190-AA999AC18ED8
#define Consumer_secret (@"11D9EF03-3443-449D-8190-AA999AC18ED8&")
#define Oauth_signature_method	(@"HMAC-SHA1") //生成签名的方式，默认值HMAC-SHA1
#define Oauth_version	(@"1.0") //String	版本号，默认
#define Oauth_callback	(@"http://www.cipnet.cn") //String	回调地址，默认

#define AddController_backgroundColor self.view.backgroundColor=[UIColor colorWithRed:(0xde)/255.0 green:(0xe1)/255.0 blue:(0xe5)/255.0 alpha:(0.0)];
#define Background_RGBACOLOR [UIColor colorWithRed:(0xde)/255.0 green:(0xe1)/255.0 blue:(0xe5)/255.0 alpha:(0.0)]
#define WHETHERTABLEHIDDEN(_TABLE,_IMAGE,_WHETHER,_RESETEDITING){_TABLE.hidden=_WHETHER;_IMAGE.hidden=!_WHETHER;if([_TABLE isKindOfClass:[UITableView class]]){_TABLE.editing=_RESETEDITING?NO:_TABLE.editing;}}

//====================================================
// 用途: 用于跳转升级的URL
//====================================================
#define UPDATE_URL @"http://bjyek.9966.org:8080/yekapi/index.php/"


//====================================================
// 用途: 判断字符串是否为空
//====================================================
#define strIsEmpty(str) (str==nil || [str length]<1 ? YES : NO )

//====================================================
#define RGBACOLOR(_r, _g, _b, _a) [UIColor colorWithRed:(_r)/255.0 green:(_g)/255.0 blue:(_b)/255.0 alpha:(_a)]




