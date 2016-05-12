//
//  ShedDetailView.m
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDetailHeaderView.h"

@implementation ShedDetailHeaderView
	UILabel *plant_name;//种植作物
	UILabel *harvest_time;//收获时间
	UILabel *area;//种植面积
	UILabel *expectation;//预估产量
	UILabel *sn;//sn
	UILabel *location;//大棚位置
	UILabel *plant_time;//种植时间
/** 加载数据  */
-(void)configDataOfHeader:(id)data{
	float width = SCREEN_WIDTH;
	UIView *rootView = [[UIView alloc] init];
	rootView.backgroundColor = [UIColor clearColor];
	rootView.frame = CGRectMake(0, 0, width, 330);
	int lableH = 45;
	int topH = 5;
	int i = 0;
	int singleLableW = 100;
	int leftM = 10;//左边距
	int doubleLableW = width-singleLableW-20;
	UIView *view = [[UIView alloc] init];
	UILabel *lable = [[UILabel alloc] init];
	
	view.frame = CGRectMake(0, (lableH+i)*i+topH, width, lableH);
	view.backgroundColor = [UIColor whiteColor];
	lable.text = @"种植作物：";
	lable.frame = CGRectMake(leftM, 0,singleLableW, lableH);
	[view addSubview:lable];
	lable = [[UILabel alloc] init];
	lable.text = @"番茄";
	plant_name = lable;
	lable.frame = CGRectMake(singleLableW, 0, doubleLableW, lableH);
	[view addSubview:lable];
	
	[rootView addSubview:view];
	
	
	i++;
	
	//第二行
	view = [[UIView alloc] init];
	view.frame = CGRectMake(0, (lableH+1)*i+topH, width, lableH);
	view.backgroundColor = [UIColor whiteColor];
	
	lable = [[UILabel alloc] init];
	lable.text = @"种植时间：";
	lable.frame = CGRectMake(leftM, 0,singleLableW, lableH);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"2015年12月16日";
	plant_time = lable;
	lable.frame = CGRectMake(singleLableW, 0, doubleLableW, lableH);
	[view addSubview:lable];
	[rootView addSubview:view];
	
	
	i++;
	
	//第三行
	view = [[UIView alloc] init];
	view.frame = CGRectMake(0, (lableH+1)*i+topH, width, lableH);
	view.backgroundColor = [UIColor whiteColor];
	
	lable = [[UILabel alloc] init];
	lable.text = @"种植面积：";
	lable.frame = CGRectMake(leftM, 0,singleLableW, lableH);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"1200平方米";
	area = lable;
	lable.frame = CGRectMake(singleLableW, 0, doubleLableW, lableH);
	[view addSubview:lable];
	[rootView addSubview:view];
	
	i++;
	
	//第二行
	view = [[UIView alloc] init];
	view.frame = CGRectMake(0, (lableH+1)*i+topH, width, lableH);
	view.backgroundColor = [UIColor whiteColor];
	
	lable = [[UILabel alloc] init];
	lable.text = @"收获时间：";
	lable.frame = CGRectMake(leftM, 0,singleLableW, lableH);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"2016年12月16日";
	harvest_time = lable;
	lable.frame = CGRectMake(singleLableW, 0, doubleLableW, lableH);
	[view addSubview:lable];
	[rootView addSubview:view];
	
	
	i++;
	
	//第二行
	view = [[UIView alloc] init];
	view.frame = CGRectMake(0, (lableH+1)*i+topH, width, lableH);
	view.backgroundColor = [UIColor whiteColor];
	
	lable = [[UILabel alloc] init];
	lable.text = @"预估产量：";
	lable.frame = CGRectMake(leftM, 0,singleLableW, lableH);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"3000公斤";
	expectation= lable;
	lable.frame = CGRectMake(singleLableW, 0, doubleLableW, lableH);
	[view addSubview:lable];
	[rootView addSubview:view];
	
	
	i++;
	
	//第二行
	view = [[UIView alloc] init];
	view.frame = CGRectMake(0, (lableH+1)*i+topH, width, lableH);
	view.backgroundColor = [UIColor whiteColor];
	
	lable = [[UILabel alloc] init];
	lable.text = @"设备SN号：";
	lable.frame = CGRectMake(leftM, 0,singleLableW, lableH);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"YYYYYYYYYYYYYYY";
	sn= lable;
	lable.frame = CGRectMake(singleLableW, 0, doubleLableW, lableH);
	[view addSubview:lable];
	[rootView addSubview:view];
	
	
	i++;
	
	//第二行
	view = [[UIView alloc] init];
	view.frame = CGRectMake(0, (lableH+1)*i+topH, width, lableH);
	view.backgroundColor = [UIColor whiteColor];
	
	lable = [[UILabel alloc] init];
	lable.text = @"大棚位置：";
	lable.frame = CGRectMake(leftM, 0,singleLableW, lableH);
	[view addSubview:lable];
	
	lable = [[UILabel alloc] init];
	lable.text = @"中国长沙";
	location = lable;
	lable.frame = CGRectMake(singleLableW, 0, doubleLableW, lableH);
	[view addSubview:lable];
	UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchUP:)];
	[lable addGestureRecognizer:singleTap1];
	lable.userInteractionEnabled = YES;
	[rootView addSubview:view];
	[self addSubview:rootView];
}

- (void)touchUP:(id)sender
{
	NSLog(@"touchUp");
}
@end
