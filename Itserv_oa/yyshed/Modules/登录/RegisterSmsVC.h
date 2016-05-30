//
//  RegisterSmsVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterInfoVC.h"

@interface RegisterSmsVC : UIViewController
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *smscode;
- (IBAction)getSMSCode:(id)sender;
- (IBAction)overClick:(id)sender;

@end
