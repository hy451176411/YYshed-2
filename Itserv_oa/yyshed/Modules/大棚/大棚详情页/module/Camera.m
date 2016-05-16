//
//  Camera.m
//  Itserv_oa
//
//  Created by mac on 16/5/12.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "Camera.h"

@implementation Camera

-(void)initCamera:(id)data{
	self.userInteractionEnabled = YES;
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.frame = CGRectMake(0, ELEMENT_SPACING, SCREEN_WIDTH, CAMERA_H);
	rootView1.userInteractionEnabled = YES;
	rootView1.backgroundColor = [UIColor whiteColor];
	//图像
	UIImage *left = [UIImage imageNamed:@"camera_offline.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame = CGRectMake(ELEMENT_SPACING, ELEMENT_SPACING, ELEMENT_IMG_W_H, ELEMENT_IMG_W_H);
	[rootView1 addSubview:img];
	
	//名字
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	view.frame = CGRectMake(ELEMENT_IMG_W_H+ELEMENT_SPACING, ELEMENT_SPACING, 200, 49);
	//上下排列的名字与sn
	UILabel *lable = [[UILabel alloc] init];
	lable.text = @"摄像头2";
	lable.frame = CGRectMake(3, 0, 200, 25);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"sn:YXF0002000000000030";
	lable.frame = CGRectMake(3, 20, 200, 25);
	lable.backgroundColor = [UIColor clearColor];
	lable.font = [UIFont systemFontOfSize:10];
	lable.textColor = [UIColor grayColor];
	[view addSubview:lable];
	[rootView1 addSubview:view];
	
	lable = [[UILabel alloc] init];
	lable.text = @"状态：";
	lable.frame = CGRectMake(SCREEN_WIDTH-120, ELEMENT_SPACING, 60, 49);
	[rootView1 addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"请连接";
	lable.frame = CGRectMake(SCREEN_WIDTH-120+60, ELEMENT_SPACING, 60, 49);
	[rootView1 addSubview:lable];
	
	
	UIImage *center = [UIImage imageNamed:@"video.png"];
	UIImageView* centerImg = [[UIImageView alloc] initWithImage:center];
	centerImg.frame = CGRectMake(ELEMENT_SPACING, 65, SCREEN_WIDTH-20, 100);
	
	int controlW = 45;
	int controlX  = 10;
	int controlY  = 170;
	int controlH = 25;
	
	UIImage *up = [UIImage imageNamed:@"video_up_unseletor.png"];
	UIImageView* upImg = [[UIImageView alloc] initWithImage:up];
	upImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX  = controlX+controlW;
	UIImage *down = [UIImage imageNamed:@"video_down_unseletor.png"];
	UIImageView* downImg = [[UIImageView alloc] initWithImage:down];
	downImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX  = controlX+controlW;
	UIImage *stop = [UIImage imageNamed:@"video_stop_unseletor.png"];
	UIImageView* stopImg = [[UIImageView alloc] initWithImage:stop];
	stopImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX  = controlX+controlW;
	UIImage *leftC = [UIImage imageNamed:@"video_left_unseletor.png"];
	UIImageView* leftImg = [[UIImageView alloc] initWithImage:leftC];
	leftImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX  = controlX+controlW;
	UIImage *right = [UIImage imageNamed:@"video_right_unseletor.png"];
	UIImageView* rightImg = [[UIImageView alloc] initWithImage:right];
	rightImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUP:)];
	[rightImg addGestureRecognizer:singleTap];
	rightImg.userInteractionEnabled = YES;
	
	lable = [[UILabel alloc] init];
	lable.text = @"更新:2016-05-12 14:41:40";
	lable.backgroundColor = [UIColor clearColor];
	//label.backgroundColor = [UIColor clearColor];
	lable.font = [UIFont systemFontOfSize:10];
	lable.textColor = [UIColor grayColor];
	lable.frame = CGRectMake(SCREEN_WIDTH-140, 190, 140, 49);
	[rootView1 addSubview:lable];
	
	[rootView1 addSubview:downImg];
	[rootView1 addSubview:upImg];
	[rootView1 addSubview:stopImg];
	[rootView1 addSubview:leftImg];
	[rootView1 addSubview:rightImg];
	[rootView1 addSubview:centerImg];

	[self addSubview:rootView1];
}
- (void)touchUP:(id)sender
{
	NSLog(@"touchUp Camera");
}
@end
