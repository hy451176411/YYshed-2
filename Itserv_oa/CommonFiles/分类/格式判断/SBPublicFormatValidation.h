//
//  SBPublicFormatValidation.h
/**
 version:1.0
 */
//  Created by xie xianhui on 13-6-23.
//  Copyright (c) 2013年 xie xianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPublicFormatValidation : NSObject

//判断字符串中是否全是汉字
+ (BOOL)boolStringAllHaveChinese:(NSString *)str;

//判断字符串中不能出现汉字
+ (BOOL)boolStringNotHaveChinese:(NSString *)str;

//验证邮箱格式
+ (BOOL)boolEmailCheckNumInput:(NSString *)_text;

//验证电话号码格式是否正确
+ (BOOL)boolCheckPhoneNumInput:(NSString *)paramPhoneNum;
@end
