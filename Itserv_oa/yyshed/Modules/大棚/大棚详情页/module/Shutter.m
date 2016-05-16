//
//  Shutter.m
//  Itserv_oa
//
//  Created by mac on 16/5/13.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "Shutter.h"

@implementation Shutter

-(void)initShutter:(id)data{
	self.userInteractionEnabled = YES;
	float width = SCREEN_WIDTH;
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.frame = CGRectMake(0, 0, width, SHUTTER_H);
	rootView1.userInteractionEnabled = YES;
	rootView1.backgroundColor = [UIColor whiteColor];
	//图像
	UIImage *left = [UIImage imageNamed:@"shutter.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame = CGRectMake(ELEMENT_SPACING, ELEMENT_SPACING, ELEMENT_IMG_W_H, ELEMENT_IMG_W_H);
	[rootView1 addSubview:img];

	//名字
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	view.frame = CGRectMake(ELEMENT_IMG_W_H+ELEMENT_SPACING, ELEMENT_SPACING, 200, 50);
	//上下排列的名字与sn
	UILabel *lable = [[UILabel alloc] init];
	lable.text = self.model[@"dev_name"];
	lable.frame = CGRectMake(3, 0, 200, 25);
	[view addSubview:lable];

	lable = [[UILabel alloc] init];
	NSString *sn = self.model[@"sn"];
	NSString *snStr = [NSString stringWithFormat:@"sn:%@",sn];
	lable.text = snStr;
	lable.frame = CGRectMake(3, 20, 200, 25);
	lable.backgroundColor = [UIColor clearColor];
	lable.font = [UIFont systemFontOfSize:10];
	lable.textColor = [UIColor grayColor];
	[view addSubview:lable];
	[rootView1 addSubview:view];

	int controlW = 40;
	int controlX  = width-ELEMENT_SPACING-controlW*3;//屏幕宽度减去右边距宽度减去三个元素的宽度
	int controlY  = 25;
	int controlH = 30;
	
	UIImage *up = [UIImage imageNamed:@"forward1_foucs.png"];
	UIImageView* upImg = [[UIImageView alloc] initWithImage:up];
	upImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX = controlX +controlW;
	UIImage *down = [UIImage imageNamed:@"forward2_focus.png"];
	UIImageView* downImg = [[UIImageView alloc] initWithImage:down];
	downImg.frame = CGRectMake(controlX, controlY, controlW, controlH);
	
	controlX = controlX +controlW;
	UIImage *stop = [UIImage imageNamed:@"forward3_focus.png"];
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
	lable.frame = CGRectMake(width-140, SHUTTER_H-25, 140, 15);
	[rootView1 addSubview:lable];
	
	[rootView1 addSubview:downImg];
	[rootView1 addSubview:upImg];
	[rootView1 addSubview:stopImg];
	[self addSubview:rootView1];
}
- (void)touchUP:(id)sender
{
	NSLog(@"touchUp shutter");
}

@end
