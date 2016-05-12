//
//  ShedDatailCenter.m
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDatailCenter.h"

@implementation ShedDatailCenter

-(void)configDataOfCenter:(id)data{
	float width = SCREEN_WIDTH;
	UIView *rootView = [[UIView alloc] init];
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.frame = CGRectMake(0, 0, width, 270);
	rootView1.backgroundColor = [UIColor whiteColor];
	
	//图像
	UIImage *left = [UIImage imageNamed:@"category2.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame = CGRectMake(10, 10, 49, 49);
	[rootView1 addSubview:img];
	
	//名字
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	view.frame = CGRectMake(59, 10, 200, 49);
	//上下排列的名字与sn
	UILabel *lable = [[UILabel alloc] init];
	lable.text = @"摄像头2";
	lable.frame = CGRectMake(3, 0, 200, 25);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"sn:yyyyyyyyyyyyy";
	lable.frame = CGRectMake(3, 20, 200, 25);
	[view addSubview:lable];
	[rootView1 addSubview:view];
	
	lable = [[UILabel alloc] init];
	lable.text = @"状态：";
	lable.frame = CGRectMake(width-120, 10, 60, 49);
	[rootView1 addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"请连接";
	lable.frame = CGRectMake(width-120+60, 10, 60, 49);
	[rootView1 addSubview:lable];
	
	
	UIImage *center = [UIImage imageNamed:@"video.png"];
	UIImageView* centerImg = [[UIImageView alloc] initWithImage:center];
	centerImg.frame = CGRectMake(10, 65, width-20, 100);
	[rootView1 addSubview:centerImg];
	
	
	[rootView addSubview:rootView1];
	[self addSubview:rootView];
}
@end
