//
//  MineEventVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/27.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDetailNav.h"
#import "NoReadEventVC.h"
#import "ReadEventVC.h"
@interface MineEventVC : UIViewController
{
	UINavigationController *mNavigationController;
	HomeDetailNav *mNavigationContent;
	NSArray *viewControllers;
}
-(void)initControls;
-(void)initTitlesAndNav;
@end