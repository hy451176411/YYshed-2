//
//  navigaController.m
//  ICViewPager
//
//  Created by mac on 16/5/12.
//  Copyright (c) 2016年 Ilter Cengiz. All rights reserved.
//

#import "HomeShedDetail.h"
#import "ShedSettingVC.h"
@interface HomeShedDetail ()

@end

@implementation HomeShedDetail

- (void)viewDidLoad {
    [super viewDidLoad];
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
	ShedDetailVC *table = [[ShedDetailVC alloc] init];
	table.title = @"详情";
	FriendGroup *group = self.friendGroup;
	NSArray *friends = group.friends;
	Component *component = friends[0];
	self.dev_id = component.sn;
	table.dev_id = self.dev_id;
	ShedSettingVC *shedSettingVc = [[ShedSettingVC alloc] init];
	shedSettingVc.title = @"设置";
	shedSettingVc.dev_id = self.dev_id;
	
	//HomeShedSettingVC *viewC2 = [[HomeShedSettingVC alloc] init];
	//viewC2.title = @"别名设置";
	//HomeShedSettingVC *viewC2 = [[HomeShedSettingVC alloc] init];
	//viewC2.title = @"设置";
	//NSArray *views = @[table, viewC,viewC2];
	NSArray *views = @[table, shedSettingVc];
	viewControllers = views;
}

//左边按键点击动作，返回处理
-(void)leftClick{
	[self.navigationController popViewControllerAnimated:YES];
}
//初始化标题和导航栏
-(void)initTitlesAndNav{
	[mNavigationContent setViewControls:viewControllers];
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
	self.title = self.friendGroup.name;
}
@end
