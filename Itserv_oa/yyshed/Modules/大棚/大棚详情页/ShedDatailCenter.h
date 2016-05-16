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
-(float)configDataOfCenter:(id)data;
@property (nonatomic, assign) id<ShedDatailCenterDelegate> delegate;
@property (nonatomic, assign) NSArray *rootModel;
@property (nonatomic, assign) NSMutableArray *cameraModel;//摄像头数组
@property (nonatomic, assign) NSMutableArray *waterModel;//节水系统数组
@property (nonatomic, assign) NSMutableArray *shutterModel;//卷帘机数组
@end
