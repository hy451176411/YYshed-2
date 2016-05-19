//
//  ShedSettingVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NickNameModule.h"
#import "StrategyMenu.h"
#import "AlarmStratey.h"

@interface ShedSettingVC : UIViewController
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, retain) YYNetRequest *theRequest;
@property (nonatomic, retain) NSString *dev_id;
@property (nonatomic,strong) NSMutableArray *modules;
@property (nonatomic,strong) NSMutableArray *mAllAlarmStratey;
@property float startY;
@end
