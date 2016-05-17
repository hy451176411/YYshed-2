//
//  ShedWater.m
//  Itserv_oa
//
//  Created by mac on 16/5/13.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedWater.h"
@implementation ShedWater
-(void)initWater:(id)data{
	
	self.userInteractionEnabled = YES;
	float width = SCREEN_WIDTH;
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.frame = CGRectMake(0, 0, width, WATER_SHED_H);
	rootView1.userInteractionEnabled = YES;
	rootView1.backgroundColor = [UIColor whiteColor];
	//图像
	UIImage *left = [UIImage imageNamed:@"water_valve.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame = CGRectMake(ELEMENT_SPACING, ELEMENT_SPACING, ELEMENT_IMG_W_H, ELEMENT_IMG_W_H);
	[rootView1 addSubview:img];
	
	//名字
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	view.frame = CGRectMake(ELEMENT_IMG_W_H+ELEMENT_SPACING, ELEMENT_SPACING, 200, 50);
	//上下排列的名字与sn
	UILabel *lable = [[UILabel alloc] init];
	//lable.text = @"卷帘机控制器";
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
	int controlX  = width-ELEMENT_SPACING-125;//屏幕宽度减去右边距宽度减去三个元素的宽度
	int controlY  = 25;
	int controlH = 30;
	
	UILabel *open = [[UILabel alloc]init];
	open.frame = CGRectMake(controlX, controlY, controlW, controlH);
	open.text = @"关闭";
	open.tag = 102;
	
	controlX = controlX +controlW;
	UIButton *onAndoff = [[UIButton alloc] init];
	onAndoff.frame = CGRectMake(controlX, controlY+3, 40, 25);
	onAndoff.tag = 101;
	onAndoff.backgroundColor = [UIColor clearColor];
	onAndoff.titleLabel.font = SystemFontOfSize(16);
	[onAndoff setImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
	[onAndoff setImage:[UIImage imageNamed:@"button_open.png"] forState:UIControlStateSelected];
	[onAndoff addTarget:self action:@selector(touchUP:) forControlEvents:UIControlEventTouchUpInside];
	onAndoff.userInteractionEnabled =YES;
	NSString *status = self.model[@"status"];
	if ([status isEqualToString:@"0"]) {
		onAndoff.selected =NO;
	}else{
		onAndoff.selected =YES;
	}

	controlX = controlX +40;
	UIImage *time = [UIImage imageNamed:@"time.png"];
	UIImageView* timeImg = [[UIImageView alloc] initWithImage:time];
	timeImg.frame = CGRectMake(controlX+5, controlY, 30, 30);
	
	lable = [[UILabel alloc] init];
	lable.text = @"更新:2016-05-12 14:41:40";
	lable.backgroundColor = [UIColor clearColor];
	lable.font = [UIFont systemFontOfSize:10];
	lable.textColor = [UIColor redColor];
	lable.frame = CGRectMake(width-140, SHUTTER_H-25, 140, 15);
	[rootView1 addSubview:lable];
	
	[rootView1 addSubview:onAndoff];
	[rootView1 addSubview:open];
	[rootView1 addSubview:timeImg];
	[self addSubview:rootView1];

}
- (void)touchUP:(id)sender
{
	NSLog(@"touchUp shutter");
	NSDictionary *touchModel = self.model;
	id temp = self.delegate;
	if (self.delegate && [self.delegate respondsToSelector:@selector(touchBtnWaterOnAndOff:withView:)]) {
		[_delegate touchBtnWaterOnAndOff:self.model withView:self];
	}
}

@end
