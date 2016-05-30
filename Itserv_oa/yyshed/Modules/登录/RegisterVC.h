//
//  RegisterVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/30.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterSmsVC.h"

@interface RegisterVC : UIViewController
- (IBAction)back:(id)sender;
- (IBAction)getSMSCode:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *phoneTF;

@end
