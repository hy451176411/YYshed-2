//
//  ShedDetailBottomMenu.h
//  Itserv_oa
//
//  Created by mac on 16/5/17.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//
/*
 底部菜单选择器部分  多个传感器显示时的选择器
 */
#import <UIKit/UIKit.h>
#import "CommonShed.h"
@protocol ShedDetailBottomMenuDelegate<NSObject>

@optional
- (void)didConfirmWithItemAtRow:(NSDictionary*)model;
@end

@interface ShedDetailBottomMenu : UIView
-(float)configDataOfBottomMenu:(id)data;
@property (nonatomic, assign) NSArray *rootModel;
@property (nonatomic, strong) NSMutableArray *menus;//传感器数组
- (void)showWithFooter:(id)sender;
@property (nonatomic, retain) UIButton *mSelectBtn;
@property (nonatomic, assign) id<ShedDetailBottomMenuDelegate> delegate;
@end
