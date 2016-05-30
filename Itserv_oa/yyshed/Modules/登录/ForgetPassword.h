//
//  ForgetPassword.h
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForgetPasswordInfo.h"

@interface ForgetPassword : UIViewController
- (IBAction)back:(id)sender;
- (IBAction)next:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *phone;
@end
