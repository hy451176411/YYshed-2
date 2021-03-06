//
//  ShedDetailView.h
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendGroup.h"
#import "CommonShed.h"
@interface ShedDetailHeaderView : UIView
@property (nonatomic, strong) UILabel *plant_name;//种植作物
@property (nonatomic, strong) UILabel *harvest_time;//收获时间
@property (nonatomic, strong) UILabel *area;//种植面积
@property (nonatomic, strong) UILabel *expectation;//预估产量
@property (nonatomic, strong) UILabel *sn;//sn
@property (nonatomic, strong) UILabel *location;//大棚位置
@property (nonatomic, strong) UILabel *plant_time;//种植时间
@property (nonatomic, strong) NSDictionary *smartgate;//大棚数据
/** 加载数据  */
- (void)configDataOfHeader:(id)data;
@end
