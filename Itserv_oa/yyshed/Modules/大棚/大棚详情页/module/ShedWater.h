//
//  ShedWater.h
//  Itserv_oa
//
//  Created by mac on 16/5/13.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonShed.h"
@protocol ShedWaterDelegate<NSObject>

@optional
- (void)touchBtnWaterOnAndOff:(NSDictionary*)model withView:(UIView*)view;

@end
@interface ShedWater : UIView
-(void)initWater:(id)data;
@property (nonatomic, retain) NSDictionary *model;
@property (nonatomic, assign) id<ShedWaterDelegate> delegate;
@end
