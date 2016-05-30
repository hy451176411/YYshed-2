//
//  ForgetPasswordInfo.m
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ForgetPasswordInfo.h"

@interface ForgetPasswordInfo ()

@end

@implementation ForgetPasswordInfo

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
	[self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)overClick:(id)sender {
}

- (IBAction)getSMSCode:(id)sender {
}
@end
