//
//  ThirdController.h
//  REPagedScrollViewExample
//
//  Created by mac on 16/5/7.
//  Copyright (c) 2016年 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDetailNav.h"
#import "ShedDetailVC.h"
#import "Component.h"
#import "ShedSettingVC.h"
#import "InformationController.h"
#import "MapController.h"

@class Component;

@interface ThirdController : UIViewController
{
	UINavigationController *mNavigationController;
	HomeDetailNav *mNavigationContent;
	NSArray *viewControllers;
}
-(void)initControls;
-(void)initTitlesAndNav;
@end
