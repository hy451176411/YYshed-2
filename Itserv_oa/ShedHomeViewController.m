//
//  ShedHomeViewController.m
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedHomeViewController.h"

@interface ShedHomeViewController ()

@end

@implementation ShedHomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"logo.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame =CGRectMake(0, 0, 30, 30);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	
	UIImage *right = [UIImage imageNamed:@"add.png"];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] init];
	UIImageView* rightIV = [[UIImageView alloc] initWithImage:right];
	UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnClick)];
	[rightIV addGestureRecognizer:singleTap];
	rightIV.frame =CGRectMake(0, 0, 25, 25);
	rightIV.backgroundColor = [UIColor clearColor];
	rightItem.customView = rightIV ;
	
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
	self.navigationItem.rightBarButtonItem =rightItem;
}

-(void)rightBtnClick{
	UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加大棚!" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
	[alter show];
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
