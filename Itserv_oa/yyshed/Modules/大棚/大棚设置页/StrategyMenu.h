//
//  StrategyMenu.h
//  Itserv_oa
//
//  Created by mac on 16/5/19.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonShed.h"
@protocol StrategyMenuDelegate<NSObject>

@optional
- (void)didConfirmWithItemAtRow:(NSDictionary*)model;
@end

@interface StrategyMenu : UIView
-(float)configDataOfBottomMenu:(id)data;
@property (nonatomic, strong) NSArray *menus;//传感器数组
- (void)showWithFooter:(id)sender;
@property (nonatomic, retain) UIButton *mSelectBtn;
@property (nonatomic, assign) id<StrategyMenuDelegate> delegate;
@end