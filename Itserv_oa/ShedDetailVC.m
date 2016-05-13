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


@interface ShedDetailVC ()<ShedDatailCenterDelegate>

@end

@implementation ShedDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
	ShedDatailCenter *mShedDetailCenter  = [[ShedDatailCenter alloc] init];
	ShedDetailHeaderView *mShedDetailHeader1  = [[ShedDetailHeaderView alloc] init];
	mShedDetailHeader1.frame = CGRectMake(0, 0, SCREEN_WIDTH, SHED_HEADER_H);
	mShedDetailCenter.frame = CGRectMake(0, SHED_HEADER_H+ELEMENT_SPACING, self.view.frame.size.width, WATER_SHED_H+CAMERA_H+SHUTTER_H+ELEMENT_SPACING*3);
	[mShedDetailCenter configDataOfCenter:nil];
	[mShedDetailHeader1 configDataOfHeader:nil];
	mShedDetailHeader1.userInteractionEnabled = YES;
	mShedDetailCenter.delegate = self;
	float ContentSize = SHED_HEADER_H+WATER_SHED_H+CAMERA_H+SHUTTER_H+ELEMENT_SPACING*5+BOTTOM_H;
	[self.mScrollView addSubview:mShedDetailHeader1];
	[self.mScrollView addSubview:mShedDetailCenter];
	[self.mScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, ContentSize)];
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

-(void)up{
	NSLog(@"up click");
}

@end
