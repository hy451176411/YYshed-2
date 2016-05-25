//
//  AboutController.m
//  Itserv_oa
//
//  Created by mac on 16/5/23.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()<UIAlertViewDelegate>

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

- (IBAction)feedback:(id)sender {
	FeedbackVC *control = [[FeedbackVC alloc] init];
	[self.navigationController pushViewController:control animated:YES];
}

- (IBAction)myEvent:(id)sender {
}

- (IBAction)logout:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提醒" message:@"是否要退出登录？" delegate:self  cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	 [alert show];
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
	NSLog(@"alertViewCancel");
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex==1) {
		YYshedLoginController *control = [[YYshedLoginController alloc] init];
		self.view.window.rootViewController = control;
	}
	NSLog(@"willDismissWithButtonIndex  %i",buttonIndex);
}
- (IBAction)aboutme:(id)sender {
	AboutMeVC *control = [[AboutMeVC alloc] init];
	//[self.navigationController pushViewController:control animated:YES];
	[self presentViewController:control animated:YES completion:nil];

}
@end
