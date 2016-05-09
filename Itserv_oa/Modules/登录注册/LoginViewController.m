//
//  LoginViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-18.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomSwitch.h"
#import "CustomIOS7AlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "SwitchingAddressViewController.h"
#import "RegistrViewController.h"

@interface LoginViewController ()
{
    IBOutlet UIView *_viewBottom;//底部视图
    IBOutlet UITextField *_fieldUser;//用户名
    IBOutlet UITextField *_fieldPwd;//密码
    IBOutlet UIView *_viewAddress;//地址
    
    
    IBOutlet UILabel *_labelAppTitle;
    
    BOOL _isOff;//是否是Java版
    __weak IBOutlet UIButton *_btnSelectAgency;
    
    __weak IBOutlet UITableView *_tableViewAgency;
    NSMutableArray  *_muArrAgency;
    
    __weak IBOutlet UITextField *_fieldCode;
    
    __weak IBOutlet UIButton *_btnRegister;
    
    __weak IBOutlet UILabel *_labelAgency;
    
    __weak IBOutlet UIView *_viewLoginBtnBg;
    
    int times;
    __weak IBOutlet UIButton *_btnGetCode;
    
    __weak IBOutlet UILabel *_labelVersion;
    
}
@property (nonatomic, retain) NSString *padCode;
@property (nonatomic, retain) NetRequest *theRequest;

@end


@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark block实现
- (void)loginSuccessBlock:(loginSuccess)login
{
    
}

#pragma mark UIButton按钮事件
- (IBAction)btnLoginClicked:(UIButton *)sender
{
    [self goLogin];
}



- (IBAction)Test
{
	
}
#pragma mark UIButton按钮事件
- (IBAction)switchClicked:(UISwitch *)sender
{
    //    NSString *strOn = [NSString stringWithFormat:@"%d",sender.on];
    //    [UserDefaults setObject:strOn forKey:@"isJave"];
    //    [UserDefaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置请求模式
    _isOff = [[UserDefaults objectForKey:@"isJava"] boolValue];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBFromColor(0x319FD1);
    _muArrAgency = [[NSMutableArray alloc] init];
    _isOff = NO;
    
    NSString *strIsDomain = [UserDefaults objectForKey:@"isJava"];
    if (strIsDomain.length == 0) {
        [UserDefaults setObject:@"0" forKey:@"isJava"];
        [UserDefaults synchronize];
        
    } else {
        _isOff = [strIsDomain boolValue];
    }
    
    self.padCode = @"";
    _viewAddress.top = NavBarHeight - 44;
    
    BOOL isRememberPwd = [UserDefaults boolForKey:kRememberPwd];
    BOOL isAutoLogin = [UserDefaults boolForKey:kAutoLogin];
    
    _labelAppTitle.text = [AppDelegate getAppDelegate].strTitleApp;
    _labelAppTitle.textColor = RGBFromColor(0x14729D);
    
    UIImage *imgOrigin = CachedImage(@"SelectType");
    CGSize size = imgOrigin.size;
    UIImage *img = [imgOrigin stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:5];
    [_btnSelectAgency setBackgroundImage:img forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton *)[_viewBottom viewWithTag:1];
    btn.selected = isRememberPwd;
    
    btn = (UIButton *)[_viewBottom viewWithTag:2];
    btn.selected = isAutoLogin;
    
    self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
    
    _fieldUser.text = [UserDefaults objectForKey:kUserName];    
    
    if (isRememberPwd) {//记住密码了
        if (_fieldUser.text) {
            
            NSString *strPwd = [UserDefaults objectForKey:_fieldUser.text];
            if (strPwd.length != 0) {
                _fieldPwd.text = strPwd;
            }
        }
    }
    _isAuto = [AppDelegate getAppDelegate].isAutoLogin;

    
    NSString *strUser = [AppDelegate getAppDelegate].strUser;
    NSString *strPass = [AppDelegate getAppDelegate].strPass;
    
    if (strUser && strPass) {//从其他app跳转过滤
        _fieldUser.text = strUser;
        _fieldPwd.text = strPass;
        if (_isAuto) {
            [self goLogin];
        }
    } else {
        if (isAutoLogin && _isAuto) {
            [self goLogin];
        }
    }
    
    _tableViewAgency.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    _tableViewAgency.layer.borderWidth = 1;
    _tableViewAgency.hidden = YES;
    
    _viewAddress.hidden = YES;
    
    //pad版加个验证码   申请后90秒后再次获取
    BOOL status = ![AppDelegate isPop3];
    _btnRegister.hidden = status;
    _btnSelectAgency.hidden = status;
    _labelAgency.hidden = status;
    
    _fieldCode.hidden = status;
    _btnGetCode.hidden = status;
    
    if ([AppDelegate isPop3]) {
        [self requestAgency];
    } else {
        if (DevicePhone) {
            _viewLoginBtnBg.top -= 40;
        } else {
            _viewLoginBtnBg.top -= 120;
        }
    }
    times = 90;
    
    _labelVersion.text = [NSString stringWithFormat:@"版本号: %@V",[SBAppMessage appVersion]];
    
    // Do any additional setup after loading the view from its nib.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)requestAgency
{

    [self.theRequest netRequestAgency];
    [SBPublicAlert showMBProgressHUD:@"加载中..." andWhereView:self.view states:NO];
}

#pragma mark 获取验证码
- (IBAction)btnGetCodeClicked:(UIButton *)sender {
    if (_fieldUser.text.length == 0) {
        //用户名不能为空
        [SBPublicAlert showMBProgressHUD:@"用户名不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else if (_fieldPwd.text.length == 0) {
        [SBPublicAlert showMBProgressHUD:@"密码不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else {
        
        sender.enabled = NO;
        
        [self.theRequest netRequestCodeUsername:_fieldUser.text bureau:_btnSelectAgency.titleLabel.text password:_fieldPwd.text];
        [SBPublicAlert showMBProgressHUD:nil andWhereView:self.view states:NO];
    }
}



- (void)countDownBtnGetCode
{
    --times;
    if (times == 0) {//可以重新获取
        _btnGetCode.enabled = YES;
        times = 90;
        [_btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];

    } else {//倒计时
        NSString *strTitle = [NSString stringWithFormat:@"%ds后再获取",times];
        [_btnGetCode setTitle:strTitle forState:UIControlStateNormal];
        
        [self performSelector:@selector(countDownBtnGetCode) withObject:nil afterDelay:1];
    }
}


#pragma mark UIButton按钮事件
- (IBAction)btnSwitchClicked:(UIButton *)sender
{
    BOOL isOn = !sender.selected;
    sender.selected = isOn;
    if (sender.tag == 1) {//记住密码
        UIButton *btn = (UIButton *)[_viewBottom viewWithTag:2];
        
        [UserDefaults setBool:isOn forKey:kRememberPwd];
        if (!isOn) {//当不记住密码时，自动登录也是NO
            btn.selected = NO;
            [UserDefaults setBool:isOn forKey:kAutoLogin];
        }
    } else {
        UIButton *btn = (UIButton *)[_viewBottom viewWithTag:1];
        [UserDefaults setBool:isOn forKey:kAutoLogin];
        if (isOn) {//当自动登录时，必须记住密码
            btn.selected = YES;
            [UserDefaults setBool:isOn forKey:kRememberPwd];
        }
    }
    [UserDefaults synchronize];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _tableViewAgency.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.top = -175;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _fieldUser) {
        [_fieldPwd becomeFirstResponder];
    } else {
        //开始登录
        [self goLogin];
    }
    return YES;
}

- (void)
:(NSString *)user pass:(NSString *)pass
{
    _fieldUser.text = user;
    _fieldPwd.text = pass;
    [self goLogin];
}

#pragma mark 进行条件验证，如果满足条件就登录
- (void)goLogin
{
    [self keyboardDisappear];
    
    if (_fieldUser.text.length == 0) {
        //用户名不能为空
        [SBPublicAlert showMBProgressHUD:@"用户名不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else if (_fieldPwd.text.length == 0) {
        //密码不能为空
        [SBPublicAlert showMBProgressHUD:@"密码不能为空" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    } else {
        
        if (DevicePad && [AppDelegate isPop3]) {
            self.padCode = _fieldCode.text;
            if (_padCode.length == 0) {
                [SBPublicAlert showMBProgressHUD:@"请输入验证码" andWhereView:self.view hiddenTime:kHiddenAlertTime];
                return;
            }
        }
        
        //是否记住密码
        BOOL status = [UserDefaults boolForKey:kRememberPwd];
        [UserDefaults setObject:_fieldUser.text forKey:kUserName];
        if (status) {
            [UserDefaults setObject:_fieldPwd.text forKey:_fieldUser.text];
        }
        [UserDefaults synchronize];
        
        [_theRequest netRequestLoginUser:_fieldUser.text password:_fieldPwd.text verifycode:_padCode];
        [SBPublicAlert showMBProgressHUD:@"正在登陆中..." andWhereView:self.view states:NO];
    }
}

/*
 {
 funcstat:0,
 funcdata:{
 result:true,
 resultinfo:"验证通过",
 userid:"bangs",
 status:"",
 addtime:""
 }
 }
 */
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    if (tag == Login) {//第一登录
        BOOL success = [model[@"result"] boolValue];
        if (success) {
            [SaveData saveMessage:model key:kUserMessage];
            
            if (_isOff) {//是java版不需要验证
                [self login_Success];
            } else {
                [_theRequest netRequestSureLoginUser:_fieldUser.text password:_fieldPwd.text tag:SureLogin];
            }
        } else {
            
        }
    } else if (tag == SureLogin) {//完全登录
        //OA地址
        NSString *strOAIP = [AppDelegate getAppDelegate].strIp;
        //邮箱地址
        NSString *strMailIP = [AppDelegate getAppDelegate].strMailIP;
        
        if ([strMailIP isEqualToString:strOAIP]) {
            [self login_Success];
        } else {
            [_theRequest netRequestSureLoginUser:_fieldUser.text password:_fieldPwd.text tag:SureMail];
        }
        
    } else if (tag == SureMail) {
        [self login_Success];
    } else if (tag == Server) {//获取机构
        [SBPublicAlert hideMBprogressHUD:self.view];
        NSArray *list = model[@"list"];
        if (list.count > 0) {
            NSDictionary *dic = list[0];
            [self btnTitleWithDic:dic];
        }
        [_muArrAgency removeAllObjects];
        [_muArrAgency addObjectsFromArray:list];
    } else if (tag == VerficationCode) {//获取验证码成功
        NSString *strInfo = model[@"resultinfo"];
        [SBPublicAlert showMBProgressHUD:strInfo andWhereView:self.view hiddenTime:kHiddenAlertTime];
        [self countDownBtnGetCode];
    }
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
    _btnGetCode.enabled = YES;
    [SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
    [self countDownBtnGetCode];
    _btnGetCode.enabled = YES;
    [SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

- (void)btnTitleWithDic:(NSDictionary *)dic
{
    NSString *orgname = dic[@"orgname"];
    [_btnSelectAgency setTitle:orgname forState:UIControlStateNormal];
    if ([AppDelegate isPop3]) {
        MailMessage *mailMessage = [MailMessage sharedInstance];
        mailMessage.strPopAddress = dic[@"popaddress"];
        mailMessage.strSmtpAddress = dic[@"smtpaddress"];
    }
}

- (void)login_Success
{
    if ([AppDelegate isPop3]) {
        BOOL isAuto = [UserDefaults boolForKey:kEmailAuto];
        if (isAuto) {
            MailMessage *mailMessage = [MailMessage sharedInstance];
            [mailMessage verifyEmail:mailMessage.strEmail mailPass:mailMessage.strPass withIsSuccess:nil];
        }
    }
 
    [SBPublicAlert showMBProgressHUD:@"登录成功" andWhereView:self.view states:YES];
    [AppDelegate getAppDelegate].isSuccess = YES;
    [self performSelector:@selector(dismissView) withObject:nil afterDelay:kHiddenAlertTime];
}



- (void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:^{
        [SBPublicAlert hideMBprogressHUD:self.view];
    }];
    _loginSuccess(self);
}

#pragma mark 键盘消失
- (void)keyboardDisappear
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.top = 0;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self keyboardDisappear];
    _tableViewAgency.hidden = YES;
}

#pragma mark 设置按钮事件
- (IBAction)btnSettingClicked:(UIButton *)sender
{
    
    __block UILabel *label = _labelAppTitle;
    SwitchingAddressViewController *ctrl = [[SwitchingAddressViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SwitchingAddressViewController"] bundle:nil];
    
    __block LoginViewController *loginCtrl = self;
    
    [ctrl setUpdateAddress:^(NSDictionary *dicAddress){
        label.text = [NSString stringWithFormat:@"%@局移动办公系统",dicAddress[@"name"]];
        
//        BOOL status = ![AppDelegate isPop3];
//        _btnRegister.hidden = status;
//        _btnSelectAgency.hidden = status;
//        _labelAgency.hidden = status;
//        
//        _fieldCode.hidden = status;
//        _btnGetCode.hidden = status;
        
        if ([AppDelegate isPop3]) {
//            if (DevicePhone) {
//                _viewLoginBtnBg.top += 40;
//            } else {
//                _viewLoginBtnBg.top += 120;
//            }
            [loginCtrl requestAgency];
        } else {
//            if (DevicePhone) {
//                _viewLoginBtnBg.top -= 40;
//            } else {
//                _viewLoginBtnBg.top -= 120;
//            }
        }
        _updateSuccess();
    }];
    ctrl.isJava = _isOff;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        UITextField *AddressOA = [alertView textFieldAtIndex:0];
        UITextField *AddressEmail = [alertView textFieldAtIndex:1];
        NSString *strOA = AddressOA.text;
        NSString *strEmail = AddressEmail.text;
        
        if (strOA.length) {
            [AppDelegate getAppDelegate].strOA = strOA;
        }
        if (strEmail.length) {
            [AppDelegate getAppDelegate].strEmail = strEmail;
        }
        if (strOA.length == 0) {
            return;
        }
        NSArray *arr = [strOA componentsSeparatedByString:@"/"];
        NSString *strIP = [NSString stringWithFormat:@"http://%@",arr[2]];
        if (strIP.length) {
            [AppDelegate getAppDelegate].strIp = strIP;
        }
    }
}

#pragma mark 显示机构
- (IBAction)btnSelectAgencyClicked:(UIButton *)sender {
    
    
    
    
    [self keyboardDisappear];
    
    if (sender.titleLabel.text.length == 0) {//没有显示机构
        [self requestAgency];
        return;
    }
    
    
    _tableViewAgency.hidden = !_tableViewAgency.hidden;
    if (!_tableViewAgency.hidden) {
        _tableViewAgency.left = _btnSelectAgency.left;
        _tableViewAgency.top = _btnSelectAgency.bottom;
        _tableViewAgency.width = _btnSelectAgency.width;
        
        NSInteger height = _muArrAgency.count * 44;
        _tableViewAgency.height = height;
        if (_tableViewAgency.bottom >= _viewBottom.height) {
            _tableViewAgency.height = _viewBottom.height - _tableViewAgency.top - 10;
        }
        [_tableViewAgency reloadData];
    }
}

#pragma mark UITableViewDetegate  arc
//有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个section中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _muArrAgency.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = SystemFontOfSize(15);
    }
    NSDictionary *dic = _muArrAgency[indexPath.row];
    cell.textLabel.text = dic[@"orgname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.hidden = YES;
    NSDictionary *dic = _muArrAgency[indexPath.row];
    [self btnTitleWithDic:dic];
}

#pragma mark 注册按钮
- (IBAction)btnRegistrationClicked:(id)sender {
    NSString *strCtrlName = [AppDelegate strCtrlName:@"RegistrViewController"];
    RegistrViewController *ctrl = [[RegistrViewController alloc] initWithNibName:strCtrlName bundle:nil];
    ctrl.arrServer = _muArrAgency;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
