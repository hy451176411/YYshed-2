//
//  EchartViewShed.h
//  Itserv_oa
//
//  Created by mac on 16/5/14.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYEchartsView.h"
#import "PYZoomEchartsView.h"
#import "CommonShed.h"

@interface EchartViewShed : UIView
@property (nonatomic, strong)  PYZoomEchartsView *kEchartView;
-(void)initAll;
@property (nonatomic, retain) NSArray *model;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *time;
@end
