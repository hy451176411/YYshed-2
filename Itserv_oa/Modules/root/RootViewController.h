//
//  RootViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-18.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : BaseViewController


+ (RootViewController *)getRootCtrl;
- (void)hiddenAllTableViewMenu;
- (void)btnWithTag:(int)tag select:(BOOL)status;
@end
