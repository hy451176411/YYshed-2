//
//  Shutter.h
//  Itserv_oa
//
//  Created by mac on 16/5/13.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//
/*
 卷帘机
 */
#import <UIKit/UIKit.h>
#import "CommonShed.h"
@protocol ShutterDelegate<NSObject>

@optional
- (void)touchShutterUP:(NSDictionary*)model;

@end
@interface Shutter : UIView
@property (nonatomic, retain) NSDictionary *model;
@property (nonatomic, assign) id<ShutterDelegate> delegate;
-(void)initShutter:(id)data;
@end
