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

@interface Shutter : UIView
@property (nonatomic, retain) NSDictionary *model;
-(void)initShutter:(id)data;
@end
