//
//  InformationController.h
//  Itserv_oa
//
//  Created by mac on 16/5/23.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonShed.h"
#import "DOPDropDownMenu.h"
#import "YYNetRequest.h"

@interface InformationController : UIViewController
@property (nonatomic, strong) NSArray *address;
@property (nonatomic, retain) NSMutableArray *provinces;
@property (nonatomic, retain) NSMutableArray *citys;
@property (nonatomic, retain) NSArray *plants;//种植作物列表
@property(nonatomic,retain)NSDictionary *currentProvince;//当前省
@property(nonatomic,strong)NSString *selectedProvince;//选中的省
@property(nonatomic,strong)NSString *selectedCity;//选中的市
@property(nonatomic,strong)NSString *selectedPlant;//选中的作物
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, retain) DOPDropDownMenu *menu;
@property (nonatomic, retain) YYNetRequest *theRequest;
-(void)initMenu;
-(void)searchPlant:(id)sender;
@end
