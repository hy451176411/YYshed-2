//
//  ForgetPasswordInfo.h
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordInfo : UIViewController
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *smscode;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)overClick:(id)sender;
- (IBAction)getSMSCode:(id)sender;

@end
