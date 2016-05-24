//
//  FeedbackVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/24.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()

@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTitle{
	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
	//添加左边的按钮
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"back_normal@2x.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftClick)];
	[img addGestureRecognizer:singleTap];
	img.frame =CGRectMake(10, 10, 16, 20);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
	
	//添加左边的按钮
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
	self.title = @"感谢你的宝贵意见";
}
//左边按键点击动作，返回处理
-(void)leftClick{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void)submit{
	
}
@end
