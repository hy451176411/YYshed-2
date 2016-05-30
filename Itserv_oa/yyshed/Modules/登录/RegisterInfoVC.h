//
//  RegisterInfoVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterInfoVC : UIViewController
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *passwordAgain;

- (IBAction)overClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *password;
@end
