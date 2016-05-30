//
//  RegisterVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

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

- (IBAction)getSMSCode:(id)sender {
	RegisterSmsVC *control = [[RegisterSmsVC alloc]init];
	[self presentViewController:control animated:NO completion:nil];

}
@end
