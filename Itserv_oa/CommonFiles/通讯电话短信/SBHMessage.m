//
//  SBHMessage.m
//  SBPublicTest
//
//  Created by SBH on 14/12/10.
//  Copyright (c) 2014年 SBH. All rights reserved.
//

#import "SBHMessage.h"
#import "AppDelegate.h"


@implementation SBHMessage

+ (SBHMessage *)shareMessage
{
    static SBHMessage *message = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        message = [[SBHMessage alloc] init];
    });
    return message;
}

#pragma mark 拨打电话
+ (void)sbhCallPhone:(NSString *)phone
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [window addSubview:callWebview];
#if __has_feature(objc_arc)

#else
    [callWebview release];
    [str release];
#endif
}

- (void)sbhSendSMSCtrl:(UIViewController *)ctrl
                  body:(NSString *)bodyMessage
         recipientsArr:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    //判断装置是否在可传送讯息的状态
    if([MFMessageComposeViewController canSendText]) {
        //设定SMS讯息内容
        controller.body = bodyMessage;
        //设定接传送对象的号码
        controller.recipients = recipients;
        //        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"SomethingElse"];//修改短信界面标题
        //设定代理
        controller.messageComposeDelegate = self;
        //显示controller的画面
        [ctrl presentViewController:controller animated:YES completion:^{
        }];
    }
#if __has_feature(objc_arc)
#else
    [controller release];
#endif
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultSent:{
            //讯息传送成功
        }break;
        case MessageComposeResultFailed:{
            //讯息传送失败
        }break;
        case MessageComposeResultCancelled:{
            //讯息被用户取消传送
        }break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
