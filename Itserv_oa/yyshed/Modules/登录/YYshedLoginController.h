//
//  LoginController.h
//  REPagedScrollViewExample
//
//  Created by mac on 16/5/7.
//  Copyright (c) 2016年 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeController.h"
#import "YYNetRequest.h"
#import "EADefine.h"
#import "RegisterVC.h"
#import "ForgetPassword.h"
#import "ScanZcodeVC.h"


@interface YYshedLoginController : UIViewController<UITextFieldDelegate,YYNetRequestDelegate,UIAlertViewDelegate>
@property (nonatomic, nonatomic) IBOutlet UIButton *mRemberPsd;
@property (nonatomic, nonatomic) IBOutlet UIButton *mAutoLogin;

@property (strong, nonatomic) IBOutlet UITextField *mUserName;
@property (strong, nonatomic) IBOutlet UITextField *mPassword;
@property (strong, nonatomic) IBOutlet UIButton *mLoginBtn;
- (IBAction)login:(id)sender;
- (IBAction)btnSwithRemeberPsd:(UIButton*)sender;
- (IBAction)btnSwithAutoLogin:(UIButton*)sender;
- (IBAction)forgetpassword:(id)sender;

- (IBAction)register:(id)sender;
@end
