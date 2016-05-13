//
//  ShedDatailCenter.h
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Camera.h"
#import "Shutter.h"
#import "ShedWater.h"

@protocol ShedDatailCenterDelegate <NSObject>

@optional
- (void)up;

@end
@interface ShedDatailCenter : UIView
-(void)configDataOfCenter:(id)data;
@property (nonatomic, assign) id<ShedDatailCenterDelegate> delegate;
@end
