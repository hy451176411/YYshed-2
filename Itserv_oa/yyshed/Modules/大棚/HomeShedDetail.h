//
//  navigaController.h
//  ICViewPager
//
//  Created by mac on 16/5/12.
//  Copyright (c) 2016年 Ilter Cengiz. All rights reserved.
//
/*
 大鹏详情的第一个进入界面
 */
#import <UIKit/UIKit.h>
#import "HomeDetailNav.h"
#import "ShedDetailVC.h"
#import "Component.h"

@class Component;
@interface HomeShedDetail : UIViewController
{
	UINavigationController *mNavigationController;
	HomeDetailNav *mNavigationContent;
	NSArray *viewControllers;
}
@property (nonatomic, strong) FriendGroup *friendGroup;
-(void)initControls;
-(void)initTitlesAndNav;
@property (nonatomic, strong) NSString *dev_id;
@end
