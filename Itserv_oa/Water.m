//
//  Water.m
//  Itserv_oa
//
//  Created by mac on 16/5/13.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "Water.h"
/*
 智能节水系统
 */
@implementation Water
int ShutterH = 80;
-(void)initWater:(id)data{
	self.userInteractionEnabled = YES;
	float width = SCREEN_WIDTH;
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.frame = CGRectMake(0, 0, width, ShutterH);
	rootView1.userInteractionEnabled = YES;
	rootView1.backgroundColor = [UIColor whiteColor];
	//图像
	UIImage *left = [UIImage imageNamed:@"category2.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame = CGRectMake(10, 10, 49, 49);
	[rootView1 addSubview:img];
	
	//名字
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	view.frame = CGRectMake(59, 10, 200, 50);
	//上下排列的名字与sn
	UILabel *lable = [[UILabel alloc] init];
	lable.text = @"卷帘机控制器";
	lable.frame = CGRectMake(3, 0, 200, 25);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"sn:yyyyyyyyyyyyy";
	lable.frame = CGRectMake(3, 20, 200, 25);
	lable.backgroundColor = [UIColor clearColor];
	lable.font = [UIFont systemFontOfSize:13];
	lable.textColor = [UIColor grayColor];
	[view addSubview:lable];
	[rootView1 addSubview:view];
	
	int controlW = 45;
	int controlX  = width-10-controlW*3;
	int controlY  = 25;
	int controlH = 25;
	
	UIImage *up = [UIImage imageNamed:@"video_up_unseletor.png"];
	UIImageView* upImg = [[UIImageView alloc] initWithImage:up];
	upImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX = controlX +controlW;
	UIImage *down = [UIImage imageNamed:@"video_down_unseletor.png"];
	UIImageView* downImg = [[UIImageView alloc] initWithImage:down];
	downImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX = controlX +controlW;
	UIImage *stop = [UIImage imageNamed:@"video_stop_unseletor.png"];
	UIImageView* stopImg = [[UIImageView alloc] initWithImage:stop];
	stopImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUP:)];
	[stopImg addGestureRecognizer:singleTap];
	stopImg.userInteractionEnabled = YES;
	
	lable = [[UILabel alloc] init];
	lable.text = @"更新:2016-05-12 14:41:40";
	lable.backgroundColor = [UIColor clearColor];
	lable.font = [UIFont systemFontOfSize:10];
	lable.textColor = [UIColor redColor];
	lable.frame = CGRectMake(width-140, ShutterH-25, 140, 15);
	[rootView1 addSubview:lable];
	
	[rootView1 addSubview:downImg];
	[rootView1 addSubview:upImg];
	[rootView1 addSubview:stopImg];
	[self addSubview:rootView1];
}

- (void)touchUP:(id)sender
{
	NSLog(@"touchUp water");
}
@end
