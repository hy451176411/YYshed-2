//
//  SaveData.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-3.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveData : NSObject

//保存用户信息
+ (void)saveMessage:(NSDictionary *)dic key:(NSString *)key;
//获取用户信息
+ (NSDictionary *)getMessageKey:(NSString *)key;
//保存cookie
+ (void)saveCookie:(NSHTTPCookie *)cookie;
//获取cookie
+ (NSDictionary *)getCookieDic;

//保存到草稿
+ (void)saveEmailDic:(NSDictionary *)dicEmail index:(NSUInteger)index;

+ (NSArray *)getEmailArr;

+ (BOOL)deleteEmailIndex:(int)index;

//保存已发送邮件
+ (void)saveSendEmailDic:(NSDictionary *)dicEmail;
+ (NSArray *)getSendEmailArr;

//删除已发送邮件
+ (void)deleteSendMailIndex:(NSInteger)index;

//保存文件
+ (void)saveAttachmentFileName:(NSString *)fileName fileData:(NSData *)data;
@end
