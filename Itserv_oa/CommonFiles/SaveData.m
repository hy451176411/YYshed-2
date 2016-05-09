//
//  SaveData.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-3.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "SaveData.h"

@implementation SaveData

#pragma mark 保存用户信息
+ (void)saveMessage:(NSDictionary *)dic key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 获取用户信息
+ (NSDictionary *)getMessageKey:(NSString *)key
{
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    return dic;
}


#pragma mark 保存cookie
+ (void)saveCookie:(NSHTTPCookie *)cookie
{
    NSDictionary *dic = @{@"name":cookie.name,@"value":cookie.value};
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"cookie"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 获取cookie
+ (NSDictionary *)getCookieDic
{
    NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]];
    return dic;
}

+ (NSString *)pathWithName
{
    NSString *email = [MailMessage sharedInstance].strEmail;
    NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    __autoreleasing NSString *strFilePath = [[NSString alloc] initWithFormat:@"%@/%@.txt",rootPath,email];
    return strFilePath;
}

#pragma mark 保存草稿
+ (void)saveEmailDic:(NSDictionary *)dicEmail index:(NSUInteger)index
{
    NSString *filePath = [SaveData  pathWithName];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:[SaveData getEmailArr]];
    
    if (index > 0) {//是从草稿箱进入编辑的
        [muArr removeObjectAtIndex:index - 1];
    }
    //    else {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dicEmail];
    NSString *strID = @"";
    if (muArr.count == 0) {
        strID = @"1";
    } else {
        NSDictionary *dic = muArr[0];
        NSInteger draftID = [dic[@"draftID"] integerValue] + 1;
        strID = [NSString stringWithFormat:@"%ld",(long)draftID];
    }
    muDic[@"draftID"] = strID;
    [muArr insertObject:muDic atIndex:0];
    //    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:muArr];
    
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"缓存成功");
    }
}


+ (NSArray *)getEmailArr
{
    NSString *filePath = [SaveData  pathWithName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *dicEmail = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dicEmail;
}


+ (BOOL)deleteEmailIndex:(int)index
{
    BOOL success = NO;
    
    NSString *filePath = [SaveData  pathWithName];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:[SaveData getEmailArr]];
    [muArr removeObjectAtIndex:index];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:muArr];
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"缓存成功");
        success = YES;
    }
    return success;
}


+ (NSString *)pathWithSendName
{
    NSString *email = [MailMessage sharedInstance].strEmail;
    NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    __autoreleasing NSString *strFilePath = [[NSString alloc] initWithFormat:@"%@/%@-SendMail.txt",rootPath,email];
    return strFilePath;
}

#pragma mark 保存已发送邮件
+ (void)saveSendEmailDic:(NSDictionary *)dicEmail
{
    NSString *filePath = [SaveData  pathWithSendName];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:[SaveData getSendEmailArr]];
    
    [muArr addObject:dicEmail];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:muArr];
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"缓存发送邮件成功");
    }
}

+ (NSArray *)getSendEmailArr
{
    NSString *filePath = [SaveData  pathWithSendName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *dicEmail = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dicEmail;
}

+ (void)deleteSendMailIndex:(NSInteger)index
{
    NSString *filePath = [SaveData  pathWithSendName];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:[SaveData getSendEmailArr]];
    [muArr removeObjectAtIndex:index];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:muArr];
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"缓存发送邮件成功");
    }
}


//保存文件
+ (void)saveAttachmentFileName:(NSString *)fileName fileData:(NSData *)data
{
    NSString *filePath = kSaveFilePath(fileName);
    if ([data writeToFile:filePath atomically:YES]) {
        NSLog(@"文件保存成功");
    }
}

@end
