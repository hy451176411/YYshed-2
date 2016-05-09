//
//  SBPublicFormatValidation.m
//
//  Created by xie xianhui on 13-6-23.
//  Copyright (c) 2013年 xie xianhui. All rights reserved.
//

#import "SBPublicFormatValidation.h"

@implementation SBPublicFormatValidation


#pragma mark 判断字符串中是否全是汉字
+ (BOOL)boolStringAllHaveChinese:(NSString *)str
{
    NSInteger length = str.length;
    int i = 0;
    for (; i < length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {//汉字的长度是3
        
            //            NSLog(@"汉字:%s",cString);
                    NSLog(@"%@",[NSString stringWithUTF8String:cString]);
        }else{
            break;
        }
    }
    if (i >= length) {
        return YES;
    }
    return NO;
}

#pragma mark 判断字符串中不能出现汉字
+ (BOOL)boolStringNotHaveChinese:(NSString *)str
{
    NSInteger length = str.length;
    int i = 0;
    for (; i < length; ++i) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char *cString = [subString UTF8String];
        if (strlen(cString) == 3) {//汉字的长度是3

            return NO;
        }
    }
    if (i >= length) {
        return YES;
    }
    return NO;
}

#pragma mark 判断邮箱格式是否正确
+ (BOOL)boolEmailCheckNumInput:(NSString *)email
{
    NSString *regex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:regex
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    
    //无符号整型数据接受匹配的数据的数目
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:email
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, email.length)];
    //NSLog(@"11位移动手机号码匹配的个数数%d",numberofMatch);
    [regularexpression release];
    if(numberofMatch > 0) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - 验证电话号码格式是否正确
+ (BOOL)boolCheckPhoneNumInput:(NSString *)paramPhoneNum
{
    NSString *Regex = @"(13[0-9]|14[57]|15[012356789]|18[02356789])\\d{8}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [mobileTest evaluateWithObject:paramPhoneNum];
}

@end
