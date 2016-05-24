//
//  AboutController.m
//  Itserv_oa
//
//  Created by mac on 16/5/23.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"logo.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame =CGRectMake(0, 0, 30, 30);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
