//
//  GlobalData.h
//  ChinaDream
//
//  Created by zhangfeng on 12-11-26.
//  Copyright (c) 2012年 eastedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//仅在appdelegate里赋值，无需做成实例变量
extern UINavigationController *GB_Nav;//全局导航条
extern int GB_OpenWaitShowCount;
extern int GB_StartYCoordinate;//起始Y坐标

/*
 GB_UserName,GB_Pwd,GB_Permission会出现多次值的更改，所以要做成实例变量，可调用set方法来改变值
 这样可以避免写太多的alloc和release
 例如：要给GB_UserName重新赋值，[GB_UserName release];GB_UserName = nil;GB_UserName=[[NSString alloc] initWithString:@"aaa"];
 现在只需要这样调用[[GlobalData sharedGlobalData] setGB_UserName:@"aaa"];
 */
@interface GlobalData : NSObject <NSCoding>

@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *userlogoSmall;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) NSString *subjects;
@property (nonatomic, retain) NSString *userlogoStatus;
@property (nonatomic, retain) NSString *sessionId;
@property (nonatomic, retain) NSString *teachtime;
@property (nonatomic, retain) NSString *birthdate;
@property (nonatomic, retain) NSString *teachplace;
@property (nonatomic, retain) NSString *userLogoLarge;
@property (nonatomic, retain) NSMutableArray *muArrSubject;

@property (nonatomic, assign) BOOL isTeacher;//是否是老师

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;


//单例
DECLARE_SINGLETON(GlobalData);

//释放所有的全局变量，在方法- (void)applicationWillTerminate:(UIApplication *)application里调用
+ (void)releaseGlobalData;

+ (void)loadBtnImg:(UIButton *)btn
       withImgName:(NSString *)imgName
withImgHighlightName:(NSString *)highlightName
 withImgSelectName:(NSString *)selectName
         withTitle:(NSString *)title
         withColor:(UIColor *)color
withHighlightColor:(UIColor *)highlightColor
   withSelectColor:(UIColor *)selectColor;

+ (void)loadBtnImg:(UIButton *)btn withImgName:(NSString *)imgName withImgHighlightName:(NSString *)highlightName;
+ (void)loadBtnBorder:(UIButton *)btn;

+ (void)loadViewBorder:(UIView *)viewBg;
//设置视图的边角弧度
+ (void)loadView:(UIView *)viewBg withRadius:(CGFloat)radius;

//计算km  返回千米
+ (NSString *)distanceM:(NSString *)strkm;

//根据出生日期获取年龄
+ (NSString *)getAgeWithBirth:(NSString *)birth;

//获取文字
+ (NSString *)nameWithSelectStr:(NSString *)strSelect;
//获取代号
+ (NSString *)codeWithSelectStr:(NSString *)strSelect;

//返回空字符串
+ (NSString *)strWithNullStr:(NSString *)str;

//调用电话 拨打电话
+ (void)callPhoneNumber:(NSString *)aPhoneNumber;

//授课方式   教学场所
+ (NSString *)strWithTeachPlace:(int)num;

//性别
+ (NSString *)strWithSex:(int)num;

//上课时间
+ (NSString *)strWithTeachTime:(int)num;
@end
