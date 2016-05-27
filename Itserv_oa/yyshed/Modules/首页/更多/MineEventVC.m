//
//  MineEventVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/27.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "MineEventVC.h"

@interface MineEventVC ()

@end

@implementation MineEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
	self.view.backgroundColor = [UIColor whiteColor];
	HomeDetailNav *control = [[HomeDetailNav alloc] init];
	//内容导航
	mNavigationContent = [[HomeDetailNav alloc]init];
	mNavigationController = [[UINavigationController alloc]initWithRootViewController:mNavigationContent];
	//初始化子视图
	[self initControls];
	[self initTitlesAndNav];
	[self.view addSubview:mNavigationController.view];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

-(void)initControls{
	NoReadEventVC *table = [[NoReadEventVC alloc] init];
	table.title = @"未读事件";
	
	ReadEventVC *shedSettingVc = [[ReadEventVC alloc] init];
	shedSettingVc.title = @"已读事件";
	
	NSArray *views = @[table, shedSettingVc];
	viewControllers = views;
}
//初始化标题和导航栏
-(void)initTitlesAndNav{
	[mNavigationContent setViewControls:viewControllers];
	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
	//添加左边的按钮
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"back_normal@2x.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backBtn)];
	[img addGestureRecognizer:singleTap];
	img.frame =CGRectMake(10, 10, 16, 20);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
	self.title = @"我的事件";
}
-(void)backBtn{
	[self.navigationController popViewControllerAnimated:YES];
}
@end

