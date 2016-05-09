//
//  GlobalData.m
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//

#import "GlobalData.h"


UINavigationController *GB_Nav = nil;

int GB_OpenWaitShowCount = 0;
int GB_StartYCoordinate = 0;

@implementation GlobalData

//实现单例
SYNTHESIZE_SINGLETONE_FOR_CLASS(GlobalData);

- (void)loadData
{
    _isTeacher = NO;
    self.sessionId = @"";
    
    if (!_muArrSubject) {
        _muArrSubject =  [[NSMutableArray alloc] init];
    }
}

//程序终止的时候释放内存
+ (void)releaseGlobalData
{
    //释放实例变量
    //释放非实例变量
    SafelyRelease(GB_Nav);
    
}

#pragma mark 设置椭圆按钮btn的图片
+ (void)loadBtnImg:(UIButton *)btn
       withImgName:(NSString *)imgName
withImgHighlightName:(NSString *)highlightName
 withImgSelectName:(NSString *)selectName
         withTitle:(NSString *)title
         withColor:(UIColor *)color
withHighlightColor:(UIColor *)highlightColor
   withSelectColor:(UIColor *)selectColor
{
    [btn setTitle:title forState:UIControlStateNormal];
    UIImage *imgOrigin = ImageWithImgName(imgName);
    CGSize size = imgOrigin.size;
    
    UIImage *img = [imgOrigin stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    //高亮
    if (highlightName && highlightName.length != 0) {
        UIImage *imgHighlightOrigin = ImageWithImgName(highlightName);
        size = imgHighlightOrigin.size;
        UIImage *imgHighlight = [imgHighlightOrigin stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
        [btn setBackgroundImage:imgHighlight forState:UIControlStateHighlighted];
    }
    //选中
    if (selectName.length != 0) {
        UIImage *imgSelectOrigin = ImageWithImgName(selectName);
        size = imgSelectOrigin.size;
        UIImage *imgSelect = [imgSelectOrigin stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
        [btn setBackgroundImage:imgSelect forState:UIControlStateSelected];
    }
    
    if (color) {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (highlightColor) {
        [btn setTitleColor:highlightColor forState:UIControlStateHighlighted];
    }
    
    if (selectColor) {
        [btn setTitleColor:selectColor forState:UIControlStateSelected];
    }
}

#pragma mark 设置椭圆按钮btn的图片
+ (void)loadBtnImg:(UIButton *)btn withImgName:(NSString *)imgName withImgHighlightName:(NSString *)highlightName
{
    UIImage *imgOrigin = ImageWithImgName(imgName);
    
    CGSize size = imgOrigin.size;
    
    UIImage *img = [imgOrigin stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    if (highlightName.length != 0) {
        UIImage *imgHighlightOrigin = ImageWithImgName(highlightName);
        size = imgHighlightOrigin.size;
        UIImage *imgHighlight = [imgHighlightOrigin stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
        [btn setBackgroundImage:imgHighlight forState:UIControlStateHighlighted];
    }
}

#pragma mark 设置首页btn边框
+ (void)loadBtnBorder:(UIButton *)btn
{
    btn.layer.borderColor = RGBFromColor(0xD3D3D3).CGColor;
    btn.layer.borderWidth = 1;
}

#pragma mark 设置边框
+ (void)loadViewBorder:(UIView *)viewBg
{
    //    viewBg.layer.borderColor = [UIColor colorWithRed:217 green:217 blue:217 alpha:1].CGColor;
    viewBg.layer.borderColor = RGBFromColor(0xDBDADE).CGColor;
    viewBg.layer.borderWidth = 1;
}

#pragma mark 设置视图的边角弧度
+ (void)loadView:(UIView *)viewBg withRadius:(CGFloat)radius
{
    viewBg.layer.masksToBounds = YES;
    viewBg.layer.cornerRadius = radius;
}


#pragma mark 计算km  返回千米
+ (NSString *)distanceM:(NSString *)strkm
{
    CGFloat distance = [strkm doubleValue] / 1000.0;
    NSString *strDistace = [NSString stringWithFormat:@"%.2fkm",distance];
    return strDistace;
}


#pragma mark 获取文字
+ (NSString *)nameWithSelectStr:(NSString *)strSelect
{
    NSString *strName = [strSelect substringFromIndex:1];
    return strName;
}

#pragma mark 获取代号
+ (NSString *)codeWithSelectStr:(NSString *)strSelect
{
    NSString *strName = [strSelect substringToIndex:1];
    return strName;
}

#pragma mark 返回空字符串
+ (NSString *)strWithNullStr:(NSString *)str
{
    if ([str isKindOfClass:[NSString class]]) {
        return str;
    }
    return @"";
}

#pragma mark 拨打电话
+ (void)callPhoneNumber:(NSString *)aPhoneNumber
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
    
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [window addSubview:phoneCallWebView];
}

#pragma mark 授课方式   教学场所
+ (NSString *)strWithTeachPlace:(int)num
{
    NSString *str = @"";
    switch (num) {
        case 0:
            str = @"不限";
            break;
        case 1:
            str = @"老师上门";
            break;
        case 2:
            str = @"学生上门";
            break;
        case 3:
            str = @"公共场所";
            break;
        default:
            break;
    }
    return str;
}

#pragma mark 性别
+ (NSString *)strWithSex:(int)num
{
    NSString *str = @"";
    switch (num) {
        case 0:
            str = @"不限";
            break;
        case 1:
            str = @"男";
            break;
        case 2:
            str = @"女";
            break;
        default:
            break;
    }
    return str;
}

#pragma mark 上课时间
+ (NSString *)strWithTeachTime:(int)num
{
    NSString *str = @"";
    switch (num) {
        case 0:
            str = @"不限";
            break;
        case 1:
            str = @"平时";
            break;
        case 2:
            str = @"周末";
            break;
        default:
            break;
    }
    return str;
}

@end
