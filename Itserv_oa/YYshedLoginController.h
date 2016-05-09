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

@interface YYshedLoginController : UIViewController<UITextFieldDelegate,YYNetRequestDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mRemberPsd;
@property (weak, nonatomic) IBOutlet UIButton *mAutoLogin;

@property (strong, nonatomic) IBOutlet UITextField *mUserName;
@property (strong, nonatomic) IBOutlet UITextField *mPassword;
@property (strong, nonatomic) IBOutlet UIButton *mLoginBtn;
- (IBAction)login:(id)sender;
- (IBAction)btnSwithRemeberPsd:(UIButton*)sender;
- (IBAction)btnSwithAutoLogin:(UIButton*)sender;

@end
