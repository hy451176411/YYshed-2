//
//  HomeController.m
//  REPagedScrollViewExample
//
//  Created by mac on 16/5/7.
//  Copyright (c) 2016年 Roman Efimov. All rights reserved.
//

#import "HomeController.h"
#import "ShedHomeViewController.h"
#import "SecondController.h"
#import "ThirdController.h"
#import "AboutController.h"

@interface HomeController ()

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tabBar.tintColor = [UIColor greenColor];
	
	self.view.backgroundColor = [UIColor clearColor];
	NSMutableArray *controllers = [NSMutableArray array];

	
	ShedHomeViewController *firstPage = [[ShedHomeViewController alloc]init];
	UINavigationController *firstNv = [[UINavigationController alloc]initWithRootViewController:firstPage];
	UIImage *firstImage = [UIImage imageNamed:@"a1.png"];
	firstPage.tabBarItem.image = firstImage;
	firstPage.title = @"i农";
	firstPage.tabBarItem.title= @"门户";
	[controllers addObject:firstNv];
	
	
	SecondController *secondPage = [[SecondController alloc]init];
	UINavigationController *secondNv = [[UINavigationController alloc]initWithRootViewController:secondPage];
	UIImage *secondImage = [UIImage imageNamed:@"a2.png"];
	secondPage.tabBarItem.image = secondImage;
	secondPage.title = @"资讯";
	[controllers addObject:secondNv];
	
	ThirdController *thirdPage = [[ThirdController alloc]init];
	UINavigationController *thirdNv = [[UINavigationController alloc]initWithRootViewController:thirdPage];
	UIImage *thirdImage = [UIImage imageNamed:@"a3.png"];
	thirdPage.tabBarItem.image = thirdImage;
	thirdPage.title = @"综合";
	[controllers addObject:thirdNv];
	
	AboutController *fourPage = [[AboutController alloc]init];
	UINavigationController *fourNv = [[UINavigationController alloc]initWithRootViewController:fourPage];
	UIImage *fourImage = [UIImage imageNamed:@"a4.png"];
	fourPage.tabBarItem.image = fourImage;
	fourPage.title = @"我的";
	[controllers addObject:fourNv];
	
	self.viewControllers = controllers;
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:213/255.0 alpha:1.0]]; 
//	UIImage *left = [UIImage imageNamed:@"logo1.png"];
//	UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:left style:UIBarButtonItemStylePlain target:self action:nil];
//	self.navigationItem.leftBarButtonItem =leftItem;

	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
