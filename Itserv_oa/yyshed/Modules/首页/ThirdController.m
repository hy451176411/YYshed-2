//
//  ThirdController.m
//  REPagedScrollViewExample
//
//  Created by mac on 16/5/7.
//  Copyright (c) 2016年 Roman Efimov. All rights reserved.
//

#import "ThirdController.h"

@interface ThirdController ()

@end

@implementation ThirdController

- (void)viewDidLoad {
    [super viewDidLoad];
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
	InformationController *table = [[InformationController alloc] init];
	table.title = @"概况";

	MapController *shedSettingVc = [[MapController alloc] init];
	shedSettingVc.title = @"地图";

	NSArray *views = @[table, shedSettingVc];
	viewControllers = views;
}
//初始化标题和导航栏
-(void)initTitlesAndNav{
	[mNavigationContent setViewControls:viewControllers];
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"u18.png"]]];
	//添加左边的按钮
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"logo.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame =CGRectMake(0, 0, 30, 30);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
}
@end
