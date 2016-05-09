//
//  LoginController.m
//  REPagedScrollViewExample
//
//  Created by mac on 16/5/7.
//  Copyright (c) 2016年 Roman Efimov. All rights reserved.
//

#import "YYshedLoginController.h"


@interface YYshedLoginController ()
@property (nonatomic, retain) NetRequest *theRequest;
@end

@implementation YYshedLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor =[UIColor whiteColor];
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
	[self.mAutoLogin setTag:TAG_REMBER_AUTOLOGIN];
	[self.mRemberPsd setTag:TAG_REMBER_PSD];
	BOOL isRememberPwd = [UserDefaults boolForKey:kRememberPwd];
	BOOL isAutoLogin = [UserDefaults boolForKey:kAutoLogin];
	
	UIButton *btn = (UIButton *)[self.view viewWithTag:TAG_REMBER_PSD];
	btn.selected = isRememberPwd;
	
	btn = (UIButton *)[self.view viewWithTag:TAG_REMBER_AUTOLOGIN];
	btn.selected = isAutoLogin;
	
	self.mUserName.text = [UserDefaults objectForKey:kUserName];
	
	if (isRememberPwd) {//记住密码了
		if (self.mUserName.text) {
			NSString *strPwd = [UserDefaults objectForKey:self.mUserName.text];
			if (strPwd.length != 0) {
				self.mPassword.text = strPwd;
			}
		}
	}

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.mUserName resignFirstResponder];
	[self.mPassword resignFirstResponder];
}


- (IBAction)login:(id)sender {
	[self goLogin];
}

- (IBAction)btnSwithRemeberPsd:(UIButton*)sender {
	BOOL isOn = !sender.selected;
	sender.selected = isOn;
	UIButton *btn = (UIButton *)[self.mRemberPsd viewWithTag:TAG_REMBER_PSD];
	[UserDefaults setBool:isOn forKey:kRememberPwd];
	if (!isOn) {//当不记住密码时，自动登录也是NO
		btn.selected = NO;
		[UserDefaults setBool:isOn forKey:kAutoLogin];
	}
	[UserDefaults synchronize];
}

- (IBAction)btnSwithAutoLogin:(UIButton*)sender {
	BOOL isOn = !sender.selected;
	sender.selected = isOn;
	UIButton *btn = (UIButton *)[self.mAutoLogin viewWithTag:TAG_REMBER_AUTOLOGIN];
	[UserDefaults setBool:isOn forKey:kAutoLogin];
	if (isOn) {//当自动登录时，必须记住密码
		btn.selected = YES;
		[UserDefaults setBool:isOn forKey:kRememberPwd];
	}
	[UserDefaults synchronize];
}
#pragma mark 进行条件验证，如果满足条件就登录
- (void)goLogin
{
	//是否记住密码
	BOOL status = [UserDefaults boolForKey:kRememberPwd];
	[UserDefaults setObject:self.mUserName.text forKey:kUserName];
	if (status) {
		[UserDefaults setObject:self.mPassword.text forKey:self.mUserName.text];
	}
	//NSString *username  = self.mUserName.text;
	//NSString *psd  = self.mPassword.text;
	NSString *username = [NSString stringWithFormat:@"%@",@"shixuepeng"];
	NSString *psd =[NSString stringWithFormat:@"%@",@"shixuepeng"];

	[UserDefaults synchronize];
		[_theRequest  login:username password:psd ];
		[SBPublicAlert showMBProgressHUD:@"正在登陆中..." andWhereView:self.view states:NO];

}

#pragma mark UIButton按钮事件
- (void)btnSwitchClicked:(UIButton *)sender
{

}

#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	if(tag == Login)
	{
		NSString* session_token = model[@"session_token"];
		[UserDefaults setObject:session_token forKey:YYSession_token];
		[SBPublicAlert showMBProgressHUD:@"登录成功" andWhereView:self.view states:YES];
		HomeController *control = [[HomeController alloc] init];
		[self presentViewController:control animated:YES completion:nil];
	}
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	NSLog(@"请求超时");
	[SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
	[SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
}
@end
