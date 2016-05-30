//
//  ForgetPassword.m
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ForgetPassword.h"

@interface ForgetPassword ()

@end

@implementation ForgetPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)next:(id)sender {
	ForgetPasswordInfo *control = [[ForgetPasswordInfo alloc]init];
	[self presentViewController:control animated:NO completion:nil];
}
@end
