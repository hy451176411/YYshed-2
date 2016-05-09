//
//  Global.h
//  Tutor
//
//  Created by syzhou on 13-11-6.
//  Copyright (c) 2013年 syzhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Global : NSObject

CGSize getSizeForLabel(UILabel* label, CGSize size);

CGSize getNSStringRect(NSString* aString, CGSize size, NSDictionary *attribute);

BOOL checkResult(id result);

NSString * handleNullString(NSString * str);

BOOL isNullOrNot(NSString *string);

AppDelegate *getAppDelegate();

NSString * stringFromDate(NSDate *date,NSString *format);

NSDate * getDateFromString(NSString *date,NSString *format);

void showAlertViewWithMessage(NSString *message, NSString *confirm,NSString *cancel);

UIColor * colorWithHexString(NSString *stringToConvert);

//MD5加密
NSString *MD5(NSString *handleString);

//先 MD5加密 然后,BASE64加密
NSString *MD5Base64String(NSString *string);

//添加阴影
void addShadow(UIView *view);

//系统的时间
NSDictionary *getSystemDate(NSDate *date);

//空值判断
BOOL isNotNULL(id object);

NSString *ascii2String(NSString *strAscii);

NSString *hexStringFromString(NSString *string);

//获取系统当前的时间 格式YYYY-MM-DD HH:mm:ss
NSString *getCurrentDate(void);

//判断一个号码是否为手机号码
BOOL isValidateMobile(NSString *mobile);

//判断是否为一个合法的银行卡号
BOOL isValidateBankCard(NSString *bankNo);

//判断一个名字
BOOL isValidateNickname(NSString *nickName);

BOOL isValidateHTML(NSString *html);

// 判断身份证号
BOOL isValidateIdentifierCard(NSString *bankCard);

// 判断当前是否为一个金额
BOOL isValidateAmount(NSString *strAmount);

//反转字符串
NSString *reverseString(NSString *StringPtr);

// 处理卡号,前六后四
NSString *handleCardNumber(NSString *cardNo);

// 普通字符串转16进制字符串
NSString *hexStringFromString(NSString *string);

//检测当前网络状态
BOOL currentNetWorkStates(void);

UIImage* imageWithImagescaledToSize(UIImage*image, CGSize newSize);

BOOL isIphone4(void);

CGRect ERCT(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

NSString *appVersion(void);

BOOL isJava(void);

float heightForString(NSString *value, float width);

@end
