//
//  AboutController.h
//  Itserv_oa
//
//  Created by mac on 16/5/23.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackVC.h"
#import "AboutMeVC.h"
#import "YYshedLoginController.h"
#import "MineEventVC.h"

@interface AboutController : UIViewController


- (IBAction)feedback:(id)sender;
- (IBAction)myEvent:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)aboutme:(id)sender;

@end
