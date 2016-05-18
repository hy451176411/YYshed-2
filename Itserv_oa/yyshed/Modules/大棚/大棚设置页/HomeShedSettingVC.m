//
//  ShedSettingVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/12.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "HomeShedSettingVC.h"

@interface HomeShedSettingVC ()

@end

@implementation HomeShedSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
	//ShedSettingNav *control = [[ShedSettingNav alloc] init];
	//内容导航
	mNavigationContent = [[ShedSettingNav alloc]init];
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
	NIckNameController *table = [[NIckNameController alloc] init];
	table.title = @"别名设置";
	
	ShedParamController *viewC = [[ShedParamController alloc] init];
	viewC.title = @"报警预案设置";
	
	
	OhterViewController *other = [[OhterViewController alloc] init];
	other.title = @"其他设置";
	//HomeShedSettingVC *viewC2 = [[HomeShedSettingVC alloc] init];
	//viewC2.title = @"设置";
	//NSArray *views = @[table, viewC,viewC2];
	NSArray *views = @[table, viewC,other];
	viewControllers = views;
}

//左边按键点击动作，返回处理
-(void)leftClick{
	[self.navigationController popViewControllerAnimated:YES];
}
//初始化标题和导航栏
-(void)initTitlesAndNav{
	[mNavigationContent setViewControls:viewControllers];
	[mNavigationContent.navigationController setNavigationBarHidden:YES];
	self.navigationController.navigationBarHidden = YES;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	//self.title = self.friendGroup.name;
}
@end
