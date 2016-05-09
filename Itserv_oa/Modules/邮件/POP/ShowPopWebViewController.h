//
//  ShowPopWebViewController.h
//  Itserv_oa
//
//  Created by admin on 15/3/23.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPopWebViewController : BaseViewController

@property (nonatomic, retain) NSString *strTopTitle;
@property (nonatomic, retain) NSData *dataFile;
@property (nonatomic, assign) int type;//1是收件箱 2是发件箱
@property (nonatomic, retain) NSString *MIMEType;
@end
