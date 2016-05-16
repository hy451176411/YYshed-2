//
//  ShedDetailVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDetailVC.h"
#import "ShedDetailHeaderView.h"
#import "ShedDatailCenter.h"
#import "ShedDetailBottom.h"


@interface ShedDetailVC ()<ShedDatailCenterDelegate>

@end

@implementation ShedDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	[self.theRequest getDeviceInfo:session_token withDev_id:self.dev_id];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

-(void)initViewsWithDatas:(NSDictionary*)model{
	float startY = 0;
	/*头部初始化*/
	self.mShedHeader  = [[ShedDetailHeaderView alloc] init];
	self.mShedHeader.frame = CGRectMake(0, startY, SCREEN_WIDTH, SHED_HEADER_H);
	self.mShedHeader.userInteractionEnabled = YES;
	NSDictionary *smartgate = model[@"smartgate"];
	self.mShedHeader.smartgate = smartgate;
	[self.mShedHeader configDataOfHeader:nil];
	[self.mScrollView addSubview:self.mShedHeader];
	startY =SHED_HEADER_H;
	/*end 头部初始化*/
	
	/*中部部初始化*/
	self.mShedCenter  = [[ShedDatailCenter alloc] init];
	self.mShedCenter.rootModel = model[@"components"];
	float centerH = [self.mShedCenter configDataOfCenter:nil];
	self.mShedCenter.frame = CGRectMake(0, startY, SCREEN_WIDTH, centerH);
	self.mShedCenter.delegate = self;
	[self.mScrollView addSubview:self.mShedCenter];
	startY = centerH+startY+ELEMENT_SPACING;
	/*end 中部初始化*/
	
	/*底部初始化*/
	self.mShedBottom = [[ShedDetailBottom alloc] init];
	self.mShedBottom.frame =CGRectMake(0, startY,SCREEN_WIDTH, ECHART_H);
	[self.mShedBottom configDataOfBottom:nil withY:startY+ECHART_H];
	[self.mScrollView addSubview:self.mShedBottom];
	startY = startY+ECHART_H+MENU_H;
	/*end 底部初始化*/
	
	/*根据头部，中部，底部的元素值动态设置滚动视图的高度*/
	float ContentSize = startY+ELEMENT_SPACING;
	[self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, ContentSize)];
}
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	[self initViewsWithDatas:model];
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	NSLog(@"请求超时");
	[SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
	[SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

@end
