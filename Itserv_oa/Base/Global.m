//
//  Global.m
//  Tutor
//
//  Created by syzhou on 13-11-6.
//  Copyright (c) 2013年 syzhou. All rights reserved.
//

#import "Global.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "AppDelegate.h"
#import "sys/utsname.h"

@implementation Global

CGSize getSizeForLabel(UILabel* label, CGSize size) {
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    return getNSStringRect(label.text, size, attribute);
}

BOOL checkResult(id result) {
    BOOL flag = NO;
    if ([result isKindOfClass:[NSDictionary class]]) {
        if (![[result objectForKey:@"status"] intValue]) {
            flag = YES;
        }
    }
    
    return flag;
}

/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
float heightForString(NSString *value, float height) {
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
//    _text.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(MAXFLOAT, height) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.width + 16;
}

CGSize getNSStringRect(NSString* aString, CGSize size, NSDictionary *attribute){
    CGSize retSize = [aString boundingRectWithSize:size
                                             options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading 
                                          attributes:attribute 
                                             context:nil].size; 
    return retSize;
}

NSString * handleNullString(NSString * str)
{
    NSString *result = nil;
    if ([str isKindOfClass:[NSNull class]]) {
        result = @"";
    } else {
        if ([str isKindOfClass:[NSString class]]) {
            if ([str isEqualToString:@"(null)"]) {
                return @"";
            } else if (![str length]) {
                return @"";
            }
        } else if (str == nil) {
            return @"";
        } else if ([str isKindOfClass:[NSNumber class]]) {
            str = [NSString stringWithFormat:@"%@",str];
        }
        result = str;
    }
    return result;
}

BOOL isNullOrNot(NSString *string)
{
    BOOL ret = NO;
    if (!string)
    {
        ret = YES;
    }
    else if ([string isKindOfClass:[NSNull class]])
    {
        ret = YES;
    }

    return ret;
}

AppDelegate *getAppDelegate(void)
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


NSString * stringFromDate(NSDate *date,NSString *format) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

NSDate * getDateFromString(NSString *date,NSString *format) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:date];
}

void showAlertViewWithMessage(NSString *message, NSString *confirm,NSString *cancel) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
    [alert show];
}

#define DEFAULT_VOID_COLOR [UIColor whiteColor]
/*十六进制转uicolor*/
UIColor * colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

NSString *MD5(NSString *handleString)
{
    const char *cStr = [handleString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

void addShadow(UIView *view)
{
    [[view layer] setShadowOffset:CGSizeMake(0, 4)];
    [[view layer] setShadowRadius:5];
    [[view layer] setShadowOpacity:1];
    [[view layer] setShadowColor:[UIColor blackColor].CGColor];
}

BOOL isNotNULL(id object)
{
    if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        if ([object isEqualToString:@"(null)"])
        {
            return NO;
        }
    }
    else if (!object)
    {
        return NO;
    }

    return YES;
}

NSString *ascii2String(NSString *hexString)
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    __autoreleasing NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
}

NSString *getCurrentDate(void)
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd  HH:mm:ss"];
    
    return [dateformatter stringFromDate:senddate];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
BOOL isValidateMobile(NSString *mobile)
{
    //手机号以13, 15,18开头,八个 \d 数字字符
    NSString *phoneRegex = @"1[0-9][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

// 判断银行卡
BOOL isValidateBankCard(NSString *bankCard)
{
    NSString *cardRegex = @"/^\\d{16,19}$|^\\d{6}\\d{10,13}$|^\\d{4}\\d{4}\\d{4}\\d{4,7}$/";
    NSPredicate *bankTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cardRegex];
    return [bankTest evaluateWithObject:bankCard];
}


// 判断身份证号
BOOL isValidateIdentifierCard(NSString *bankCard)
{
    NSString *cardRegex = @"/(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)/";
    NSPredicate *bankTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",cardRegex];
    return [bankTest evaluateWithObject:bankCard];
}

//判断姓名
BOOL isValidateNickname(NSString *nickName)
{
    NSString *nameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
    return [nameTest evaluateWithObject:nickName];
}

BOOL isValidateHTML(NSString *html)
{
    return [html containsString:@"<BR>"] || [html containsString:@"<br>"] || [html containsString:@"style"] || [html containsString:@"SPAN"];
//    NSString *nameRegex = @"<(.*)(.*)>.*<\\/\1>|<(.*)\\/>";
//    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameRegex];
//    return [nameTest evaluateWithObject:html];
}


BOOL isValidateAmount(NSString *strAmount)
{
    NSString *amountRegex = @"^(([1-9]\\d{0,4})(\\.\\d{1,2})?)$|(0\\.0?([1-9]\\d?))$";
    NSPredicate *amountTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",amountRegex];
    return [amountTest evaluateWithObject:strAmount];
}

NSString *reverseString(NSString *StringPtr)
{
    int length = (int)[StringPtr length];
     NSMutableString *reversedString;

    reversedString = [[NSMutableString alloc] initWithCapacity: length];
     while (length > 0)
     {
           [reversedString appendString:[NSString stringWithFormat:@"%C", [StringPtr characterAtIndex:--length]]];
      }
  
     return reversedString;
}

NSString *handleCardNumber(NSString *cardNo)
{
    if (!cardNo)
        return  @"";
    
    NSString *strHeader = [cardNo substringWithRange:NSMakeRange(0, 6)];
    NSString *strTail = [cardNo substringWithRange:NSMakeRange(cardNo.length - 4, 4)];
    
    NSString *strStar = @"";
    for (int i = 0; i < 4; i++)
    {
        strStar = [strStar stringByAppendingString:@"*"];
    }
    return [NSString stringWithFormat:@"%@%@%@", strHeader , strStar, strTail];
}

NSString *hexStringFromString(NSString *string)
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for (int  i = 0; i < [myD length]; i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i] & 0xff]; ///16进制数
        if ([newHexStr length] == 1)
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
    }
    return  hexStr;
}

//UIImage* imageWithImagescaledToSize(UIImage*image, CGSize newSize)
//{
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//    
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // End the context
//    UIGraphicsEndImageContext();
//    
//    // Return the new image.
//    return [newImage imageWithScale:0.0001];
//}

CGRect ERCT(CGFloat x, CGFloat y, CGFloat width, CGFloat height) {
    return CGRectMake(x, y, width, height);
}

NSString *appVersion(void)
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

BOOL isJava(void) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isJava"];
}

@end
