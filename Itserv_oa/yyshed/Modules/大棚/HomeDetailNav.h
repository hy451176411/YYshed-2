//
//  HostViewController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//
/*
 添加详情页和设置页作为大鹏的子页
 */
#import <QuartzCore/QuartzCore.h>

#import "ViewPagerController.h"

@interface HomeDetailNav : ViewPagerController
@property (nonatomic, copy) NSArray *viewControllers;

-(void)setViewControls: (NSArray*)controls;

@end
