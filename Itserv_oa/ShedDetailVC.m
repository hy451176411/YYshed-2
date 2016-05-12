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
	mShedDetailHeader1.frame = CGRectMake(0, 10, self.view.frame.size.width, 330);
	mShedDetailCenter.frame = CGRectMake(0, 330, self.view.frame.size.width, 460);
	[mShedDetailCenter configDataOfCenter:nil];
	[mShedDetailHeader1 configDataOfHeader:nil];
	mShedDetailHeader1.userInteractionEnabled = YES;
	mShedDetailCenter.delegate = self;
	[self.mScrollView addSubview:mShedDetailHeader1];
	[self.mScrollView addSubview:mShedDetailCenter];
	[self.mScrollView setContentSize:CGSizeMake(320, 2000)];
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

-(void)up{
	NSLog(@"up click");
}

@end
