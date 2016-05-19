//
//  AlarmStratey.h
//  Itserv_oa
//
//  Created by mac on 16/5/19.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmStrateyItem.h"

@interface AlarmStratey : NSObject
@property (nonatomic, retain) NSString *strategy_id;
@property (nonatomic, retain) NSString *strategy_name;
@property (nonatomic, retain) NSMutableArray *strategyitems;
-(void)initAlarmStratey:(NSDictionary*)model;
@end
