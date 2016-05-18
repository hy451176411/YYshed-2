//
//  ShedSettingNav.h
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewPagerController.h"

@interface ShedSettingNav : ViewPagerController
@property (nonatomic, copy) NSArray *viewControllers;

-(void)setViewControls: (NSArray*)controls;

@end