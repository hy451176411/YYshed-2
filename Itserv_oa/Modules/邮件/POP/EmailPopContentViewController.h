//
//  EmailContentViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

@interface EmailPopContentViewController : BaseViewController

@property (nonatomic, retain) NSDictionary *dicEmail;
@property (nonatomic, retain) NSDictionary *dicSendEmail;
@property (nonatomic, strong) MCOMessageParser *messageParser;
@end
