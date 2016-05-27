//
//  YYNetRequest.h
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "CommonShed.h"
#import "BaseModel.h"


#import "EADefine.h"

@class NetRequest;


@protocol YYNetRequestDelegate <NSObject>

@optional
/*
 *不管请求成功失败，都走下面的请求完成回调
 */
- (void)netRequest:(int)tag Finished:(NSDictionary *)model;
- (void)netRequest:(int)tag Failed:(NSDictionary *)model;
- (void)netRequest:(int)tag requestFailed:(NSString *)message;
- (void)netRequest:(int)tag Finished:(NSDictionary *)model withView:(UIView*)view ;
@end
@interface YYNetRequest : NSObject<ASIHTTPRequestDelegate>

@property (retain, nonatomic) NSMutableDictionary *requestDic;

@property (nonatomic, assign) id <YYNetRequestDelegate>delegate;


@property (nonatomic,retain) NSString *screct;
@property (nonatomic, retain) NSString *oauth_token;
@property (nonatomic, retain) NSString *oauth_verifier;
@property (nonatomic, retain) UIView *touchView;//点击了那个view，那个view发起的请求，回来对那个view做处理

- (void)startAsynchronousWithRequest:(ASIHTTPRequest *)request;

/*
 *
 *setDelegate when init
 *
 */
- (id)initWithDelegate:(id <NetRequestDelegate>)aDelegate;
//登录接口
-(void)login:(NSString*) username password:(NSString*) psd;
//获取大鹏首页数据
-(void)getUserInfo:(NSString*)session_token user_Agent:(NSString*)Agent;
//获取大棚详情页数据
-(void)getDeviceInfo:(NSString*)session_token withDev_id:(NSString*)dev_id;
//节水系统的开关操作
-(void)opeErelay:(NSString*)session_token withDev_id:(NSString*)dev_id withComponentId:(NSString*) componentId withAction:(NSString*)action;
//获取图标数据
-(void)getAnalysisResult:(NSString*)sn withType:(NSString*)type withScope:(NSString*)scope;
//获取大棚的strategy
-(void)getShedStrategy:(NSString*)session_token withDevUuid:(NSString*)dev_uuid;
// 获取指定省市和农作物的总体统计信息(InfomationPage)
-(void)devgeogroupInfo:(NSString*)province_name withCityName:(NSString*)city_name withPlantName:(NSString*)plant_name;
//更新大棚别名
-(void)updateDevAlias:(NSString*)devUuid withAlias:(NSString*)alias;

//更新大棚传感器别名
-(void)updateDevComponentAlias:(NSString*)component_id withAlias:(NSString*)alias;
//获取大棚的资讯栏目
-(void)getColumnList;
//获取栏目内容
-(void)getContentList:(NSString*)columnid withStart:(NSInteger)start withLimit:(NSInteger)limit;
//获取栏目广告内容
-(void)getAdverList:(NSString*)columnid withStart:(NSInteger)start withLimit:(NSInteger)limit;
//添加大棚设备
-(void)addDevice:(NSString*)devUuid withAlias:(NSString*)alias;
@end
