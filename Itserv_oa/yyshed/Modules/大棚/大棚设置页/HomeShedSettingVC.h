//
//  ShedSettingVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/12.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShedSettingNav.h"
#import "NIckNameController.h"
#import "ShedParamController.h"
#import "OhterViewController.h"

@interface HomeShedSettingVC : UIViewController
{
	UINavigationController *mNavigationController;
	ShedSettingNav *mNavigationContent;
	NSArray *viewControllers;
}
-(void)initControls;
-(void)initTitlesAndNav;
@property (nonatomic, strong) NSString *dev_id;
@end
