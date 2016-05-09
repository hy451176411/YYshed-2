//
//  BindingEmailViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 15/2/4.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import "BindingEmailViewController.h"

@interface BindingEmailViewController ()
{
    
    __weak IBOutlet UIButton *_btnBing;
    __weak IBOutlet UITextField *_fieldPass;
    __weak IBOutlet UITextField *_fieldEmail;
}
@end

@implementation BindingEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.strTitle = @"绑定邮箱";

    _fieldEmail.text = @"test";
    _fieldPass.text = @"12345678";
    
    BOOL isEmailLogin = [MailMessage sharedInstance].isMailLogin;
    if (isEmailLogin) {//已绑定邮箱
        [_btnBing setTitle:@"注销" forState:UIControlStateNormal];
        self.strTitle = @"注销邮箱";
    }
    
    // Do any additional setup after loading the view.
}


- (void)setAutoBool:(BOOL)isAuto
{
    if (!isAuto) {
        self.strTitle = @"绑定邮箱";
        [_btnBing setTitle:@"绑定" forState:UIControlStateNormal];
    } else {
        self.strTitle = @"注销邮箱";
        [_btnBing setTitle:@"注销" forState:UIControlStateNormal];
    }
    [UserDefaults setBool:isAuto forKey:kEmailAuto];
    [UserDefaults synchronize];
}

#pragma mark 绑定
- (IBAction)btnBindingEmailClicked:(id)sender {
    
    __block BindingEmailViewController *ctrl = self;
    
    MailMessage *message = [MailMessage sharedInstance];
    BOOL isEmailLogin = message.isMailLogin;
    if (isEmailLogin) {//已绑定邮箱
        [message logoutEmailWithIsSuccess:^(BOOL success){
            if (success) {
                [ctrl setAutoBool:NO];
            } else {
                [SBPublicAlert showMBProgressHUD:@"注销失败" andWhereView:self.view hiddenTime:kHiddenAlertTime];
            }
        }];
        return;
    }
//    if (![SBPublicFormatValidation boolEmailCheckNumInput:_fieldEmail.text]) {
//        [SBPublicAlert showMBProgressHUD:@"邮箱格式不正确，请重新输入您的邮箱" andWhereView:self.view hiddenTime:kHiddenAlertTime];
//    } else
    
    if (_fieldPass.text.length == 0) {
        [SBPublicAlert showMBProgressHUD:@"请输入密码" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else {
        __block BindingEmailViewController *ctrl = self;
        [message verifyEmail:_fieldEmail.text
                                         mailPass:_fieldPass.text
                                    withIsSuccess:^(BOOL success){
                                        if (success) {
                                            [ctrl verifySuccess];
                                        } else {
                                            [SBPublicAlert showMBProgressHUD:@"绑定失败" andWhereView:self.view hiddenTime:kHiddenAlertTime];
                                        }
        }];
    }
}

- (void)verifySuccess
{
    [self setAutoBool:YES];
    [UserDefaults setObject:_fieldEmail.text forKey:kEmail];
    [UserDefaults setObject:_fieldPass.text forKey:kMailPass];
    [UserDefaults synchronize];
    [SBPublicAlert showMBProgressHUD:@"绑定成功" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    [self performSelector:@selector(popView) withObject:nil afterDelay:kHiddenAlertTime];
}

- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
