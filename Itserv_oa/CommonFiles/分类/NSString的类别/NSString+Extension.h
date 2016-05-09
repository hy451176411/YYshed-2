//
//  NSString+Extension.h
/**
 version:1.0
 */
//  Created by xie xianhui on 13-6-23.
//  Copyright (c) 2013年 xie xianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (Extension)

//对URL中的中文进行编码的方法
- (NSString *)stringEncodeWithURLString:(NSString *)theStr;
//对url编码格式进行解码
- (NSString *)stringDecodingUrlEncoding;

//根据文字，字号及固定宽(固定高)来计算高(宽)
- (CGSize)sizeWithStringFontSize:(CGFloat)fontsize
                       sizewidth:(CGFloat)width
                      sizeheight:(CGFloat)height;

//根据文字，字体，字号及固定宽(固定高)来计算高(宽)
- (CGSize)sizeWithStringFont:(UIFont *)theFont
                       sizewidth:(CGFloat)width
                      sizeheight:(CGFloat)height;

//根据文字，字体，字号及固定宽(固定高)来计算高(宽)
- (CGSize)sizeWithTextViewStringFont:(UIFont *)theFont
                   sizewidth:(CGFloat)width
                  sizeheight:(CGFloat)height;


//字符串数组转换成一个字符串
- (NSString *)stringWithStringArray:(NSArray *)tmpArr;

//拼接一个get请求URL
- (NSString *)stringGETUrlWithDic:(NSDictionary *)theDic;

//md5加密字符串
- (NSString *)stringMd5:(NSString *)str;

//md5加密文件内容
- (NSString *)stringMd5ForFileContent:(NSString *)file;

//md5 加密data
- (NSString *)stringMd5ForData:(NSData *)data;

//清除所有html标签
-(NSString *)stringFilterHTML;
@end
