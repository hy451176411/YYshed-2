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
	ShedDatailCenter *mShedDetailCenter  = [[ShedDatailCenter alloc] init];
	ShedDetailHeaderView *mShedDetailHeader1  = [[ShedDetailHeaderView alloc] init];
	mShedDetailHeader1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SHED_HEADER_H);
	mShedDetailCenter.frame = CGRectMake(0, SHED_HEADER_H+ELEMENT_SPACING, self.view.frame.size.width, WATER_SHED_H+CAMERA_H+SHUTTER_H+ELEMENT_SPACING*3);
	[mShedDetailCenter configDataOfCenter:nil];
	[mShedDetailHeader1 configDataOfHeader:nil];
	mShedDetailHeader1.userInteractionEnabled = YES;
	mShedDetailCenter.delegate = self;
	float ContentSize = SHED_HEADER_H+WATER_SHED_H+CAMERA_H+SHUTTER_H+ELEMENT_SPACING*7+BOTTOM_H+ECHART_H+MENU_H;
	
	ShedDetailBottom *bottom = [[ShedDetailBottom alloc] init];
	bottom.frame =CGRectMake(0, SHED_HEADER_H+WATER_SHED_H+CAMERA_H+SHUTTER_H+ELEMENT_SPACING*4,SCREEN_WIDTH, ECHART_H+MENU_H);
	[bottom configDataOfBottom:nil withY:SHED_HEADER_H+WATER_SHED_H+CAMERA_H+SHUTTER_H+ELEMENT_SPACING*6+ECHART_H];
	
	[self.mScrollView addSubview:mShedDetailHeader1];
	[self.mScrollView addSubview:mShedDetailCenter];
	[self.mScrollView addSubview:bottom];
	[self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, ContentSize)];
	//YXF0002000000000029
	NSString *dev = self.dev_id;
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	[self.theRequest getDeviceInfo:session_token withDev_id:self.dev_id];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

-(void)up{
	NSLog(@"up click");
}
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
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
