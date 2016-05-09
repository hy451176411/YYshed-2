//
//  LoginViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-18.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetRequest.h"
@class LoginViewController;
//申明block
typedef void(^loginSuccess)(LoginViewController *loginCtrl);
typedef void(^UpdateSuccess)();

@interface LoginViewController : UIViewController<UITextFieldDelegate,NetRequestDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isAuto;
@property (nonatomic, copy) loginSuccess loginSuccess;
@property (nonatomic, copy) UpdateSuccess updateSuccess;
//传递block块
- (void)loginSuccessBlock:(loginSuccess)login;

- (void)gologinWithUser:(NSString *)user pass:(NSString *)pass;

@end
