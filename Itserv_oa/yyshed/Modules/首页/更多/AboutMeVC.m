//
//  AboutMeVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/24.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "AboutMeVC.h"

@interface AboutMeVC ()

@end

@implementation AboutMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}
//左边按键点击动作，返回处理
- (IBAction)back:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
