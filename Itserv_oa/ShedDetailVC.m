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

@interface ShedDetailVC ()

@end

@implementation ShedDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
	ShedDatailCenter *mShedDetailCenter  = [[ShedDatailCenter alloc] init];
	ShedDetailHeaderView *mShedDetailHeader1  = [[ShedDetailHeaderView alloc] init];
	mShedDetailCenter.frame = CGRectMake(0, 330, self.view.frame.size.width, 270);
	[mShedDetailCenter configDataOfCenter:nil];
	[mShedDetailHeader1 configDataOfHeader:nil];
	[self.mScrollView addSubview:mShedDetailHeader1];
	[self.mScrollView addSubview:mShedDetailCenter];
	[self.mScrollView setContentSize:CGSizeMake(320, 2000)];
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}


@end
