//
//  SBHMessage.h
//  SBPublicTest
//
//  Created by SBH on 14/12/10.
//  Copyright (c) 2014年 SBH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

typedef void(^SendSMSSuccess)(BOOL isStatus);


@interface SBHMessage : NSObject<MFMessageComposeViewControllerDelegate>

@property (nonatomic, copy) SendSMSSuccess sendSMSSuccess;

+ (SBHMessage *)shareMessage;

//拨打电话
+ (void)sbhCallPhone:(NSString *)phone;

//发送短信
- (void)sbhSendSMSCtrl:(UIViewController *)ctrl
                  body:(NSString *)bodyMessage
         recipientsArr:(NSArray *)recipients;


@end
