
//
//  PeopleMessageView.m
//  Itserv_oa
//
//  Created by admin on 15/3/24.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import "PeopleMessageView.h"
#import "UIView+SBHLayerSet.h"
#import "SBHMessage.h"
#import "SendEmailViewController.h"
#import "SendEmailPOPViewController.h"
#import "BindingEmailViewController.h"

@implementation PeopleMessageView

- (void)awakeFromNib
{
    self.width = ScreenWidth;
    self.height = ScreenHeight;
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [_viewBg layerWithRadius:5];
    _viewBg.center = self.center;
}

/*
 {
 mail = "\U5b87\U65b9\U6210";
 orgid = 000000000;
 orgname = "\U8fbd\U5b81\U5c40";
 orgparentid = "";
 personid = 00000010;
 personname = "\U5b87\U65b9\U6210";
 phoneno = "";
 username = yufc;
 }
 */
#pragma mark 加载数据
- (void)loadDataRADataObject:(RADataObject *)raDataObj {
    NSDictionary *dic = raDataObj.dicOrgparent;
    self.dicPeople = dic;
    
    NSString *title = @"";
    NSString *phone = @"";
    NSString *mail = @"";
    
    if ([AppDelegate isPop3]) {//pop3
        title = dic[@"personname"];
        phone = dic[@"cellphone"];
        mail = dic[@"mail"];
    } else {
        title = dic[@"personname"];
        phone = dic[@"phoneno"];
        mail = dic[@"mail"];
    }
    
    _labelTitle.text = title;
    _labelPhone.text = [NSString stringWithFormat:@"手机号码：%@",phone];
    _labelMail.text = [NSString stringWithFormat:@"电子邮件：%@",mail];
    
    BOOL phoneHidden = NO;
    BOOL mailHidden = NO;
    if (phone.length == 0) {
        phoneHidden = YES;
    }
    
    if (mail.length == 0) {
        mailHidden = YES;
    }
    if (DevicePad) {
        phoneHidden = YES;
    }
    _btnPhone.hidden = phoneHidden;
    _btnMessage.hidden = phoneHidden;
    _btnEmail.hidden = mailHidden;
}

#pragma mark  拨打电话
- (IBAction)btnCallPhoneClicked:(id)sender {
    NSString *strPhone = @"";
    if ([AppDelegate isPop3]) {//pop3
        strPhone = _dicPeople[@"cellphone"];
    } else {
        strPhone = _dicPeople[@"phoneno"];
    }
    //如果电话为空就不能拨打电话
    if (strPhone) {
        [SBHMessage sbhCallPhone:strPhone];
    }
    [self removeFromSuperview];
}

#pragma mark 发短信
- (IBAction)btnSendMessageClicked:(id)sender {
    NSString *strPhone = @"";
    if ([AppDelegate isPop3]) {//pop3
        strPhone = _dicPeople[@"cellphone"];
    } else {
        strPhone = _dicPeople[@"phoneno"];
    }
    
    SBHMessage *message = [SBHMessage shareMessage];
    [message sbhSendSMSCtrl:[AppDelegate getNav]
                       body:@""
              recipientsArr:@[strPhone]];
    [self removeFromSuperview];
}

#pragma mark  发送邮件
- (IBAction)btnSendMailClicked:(id)sender {
    if ([AppDelegate isPop3]) {
        BOOL isEmailLogin = [MailMessage sharedInstance].isMailLogin;
        if (!isEmailLogin) {
            BindingEmailViewController *ctrl = [[BindingEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"BindingEmailViewController"] bundle:nil];
            [[AppDelegate getNav] pushViewController:ctrl animated:YES];
            return;
        }
        
        RADataObject *radataObject = [[RADataObject alloc] init];
        radataObject.dicOrgparent = _dicPeople;
        NSArray *toArr = [NSArray arrayWithObject:radataObject];
        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
        [muDic setObject:toArr forKey:@"to"];
        [muDic setObject:@[] forKey:@"cc"];
        [muDic setObject:@[] forKey:@"bcc"];
        [muDic setObject:@[] forKey:@"arrAttachment"];
        [muDic setObject:@"" forKey:@"subject"];
        [muDic setObject:@"" forKey:@"content"];
        
        SendEmailPOPViewController *ctrl = [[SendEmailPOPViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailPOPViewController"] bundle:nil];
        ctrl.type = SendMail;
        NSDictionary *dic = muDic;
        ctrl.dicDraft = dic;
        [[AppDelegate getNav] pushViewController:ctrl animated:YES];
    } else {
        SendEmailViewController *ctrl = [[SendEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailViewController"] bundle:nil];
        ctrl.type = PeopleSendMail;
        ctrl.dicPeople = _dicPeople;
        [[AppDelegate getNav] pushViewController:ctrl animated:YES];
    }
    [self removeFromSuperview];
}

#pragma mark  确定按钮事件
- (IBAction)btnSureClicked:(id)sender {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
