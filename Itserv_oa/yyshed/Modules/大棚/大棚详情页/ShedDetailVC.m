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
#import "ShedDetailBottomMenu.h"
#import "EADefine.h"

@interface ShedDetailVC ()<ShutterDelegate,ShedWaterDelegate,ShedDetailBottomMenuDelegate>

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
	self.startY = 0;
	/*头部初始化*/
	self.mShedHeader  = [[ShedDetailHeaderView alloc] init];
	self.mShedHeader.frame = CGRectMake(0, self.startY, SCREEN_WIDTH, SHED_HEADER_H);
	self.mShedHeader.userInteractionEnabled = YES;
	NSDictionary *smartgate = model[@"smartgate"];
	self.mShedHeader.smartgate = smartgate;
	[self.mShedHeader configDataOfHeader:nil];
	[self.mScrollView addSubview:self.mShedHeader];
	self.startY =SHED_HEADER_H;
	/*end 头部初始化*/
	
	/*中部部初始化*/
	self.mShedCenter  = [[ShedDatailCenter alloc] init];
	self.mShedCenter.rootModel = model[@"components"];
	self.mShedCenter.delegate = self;
	float centerH = [self.mShedCenter configDataOfCenter:nil];
	self.mShedCenter.frame = CGRectMake(0, self.startY, SCREEN_WIDTH, centerH);
	
	[self.mScrollView addSubview:self.mShedCenter];
	self.startY = centerH+self.startY+ELEMENT_SPACING;
	/*end 中部初始化*/
	
	/*底部初始化*/
	ShedDetailBottomMenu *menu = [[ShedDetailBottomMenu alloc] init];
	NSMutableArray *menus = [self configMenus:model[@"components"]];
	menu.menus = menus;
	float menuH = [menu configDataOfBottomMenu:nil];
	menu.frame = CGRectMake(0, self.startY,SCREEN_WIDTH, MENU_H);
	menu.delegate = self;
	[self.mScrollView addSubview:menu];
	self.startY = self.startY+menuH+ELEMENT_SPACING;
	self.startY = self.startY;
	/*end 底部初始化*/
	
	/*根据头部，中部，底部的元素值动态设置滚动视图的高度*/
	//float ContentSize = self.startY+BOTTOM_H;
	[self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.startY)];
	//[self initCharts:menus[0]];
}

-(NSMutableArray*)configMenus:(NSArray*)model{
	NSMutableArray *menus=[NSMutableArray array];
	NSArray *array = model;
	for (int i=0; i<array.count; i++) {
		NSDictionary *dic = array[i];
		if (dic) {
			NSString *dev_type = dic[@"dev_type"];
			if ([dev_type isEqualToString:@"illumination"] || [dev_type isEqualToString:@"humidity-temperature"]) {
				[menus addObject:dic];
			}
		}
	}
	return menus;
}
-(void)initBottom:(NSDictionary*)model{
	NSString *result = model[@"result"];
	if ([result isEqualToString:@"OK"]) {
		NSDictionary *msg = model[@"msg"];
		NSDictionary *data = msg[@"data"];
		self.mShedBottom = [[ShedDetailBottom alloc] init];
		self.mShedBottom.model = data;
		float bottomH = [self.mShedBottom configDataOfBottom:nil];
		self.mShedBottom.frame =CGRectMake(0, self.startY,SCREEN_WIDTH, bottomH);
		[self.mScrollView addSubview:self.mShedBottom];
		self.startY = self.startY+bottomH+ELEMENT_SPACING;
		float ContentSize = self.startY+BOTTOM_H;
		[self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, ContentSize)];
	}
	
}
- (void)didConfirmWithItemAtRow:(NSDictionary*)model{
	NSLog(@"didConfirmWithItemAtRow %@",model);
	[self initCharts:model];
}
- (void)touchShutterUP:(NSDictionary*)model{
	NSLog(@"touchShutterUP---%@",model);
}
-(void)initCharts:(NSDictionary*)menu{
	NSString *sn = menu[@"sn"];
	NSString *dev_type = menu[@"dev_type"];
	NSString *scope = @"scope2";
	[self.theRequest getAnalysisResult:sn withType:dev_type withScope:scope];
}
- (void)touchBtnWaterOnAndOff:(NSDictionary*)model withView:(UIView*)view{
	NSLog(@"touchShutterUP---%@",model);
	NSString *status = model[@"status"];
	if ([status isEqualToString:@"0"]) {
		//onAndoff.selected =NO;
		
	}else{
		//onAndoff.selected =YES;
	}
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	self.theRequest.touchView = view;
	[self.theRequest opeErelay:session_token withDev_id:self.dev_id withComponentId:model[@"sn"] withAction:model[@"status"]];
}

#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	if (tag == YYShed_getDeviceInfo) {
		//[self initViewsWithDatas:model];
	}else if(tag == YYShed_getAnalysisResult){
		[self initBottom:model];
	}
	
}
- (void)netRequest:(int)tag Finished:(NSDictionary *)model withView:(UIView*)view {
	if(tag == YYShed_openErelay){
		NSString *ret = model[@"ret"];
		if([ret isEqualToString:@"success"]){
			UILabel *touchLable = (UILabel *)[view viewWithTag:102];
			UIButton *touchButton = (UIButton *)[view viewWithTag:101];
			Boolean isSelected = touchButton.isSelected;
			if (isSelected) {
				touchButton.selected = false;
				touchLable.text = @"关闭";
			}else{
				touchButton.selected = true;
				touchLable.text = @"打开";
			}
		}
	}
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
