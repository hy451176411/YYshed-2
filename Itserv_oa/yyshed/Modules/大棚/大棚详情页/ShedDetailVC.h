//
//  ShedDetailVC.h
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendGroup.h"
#import "ShedDetailHeaderView.h"
#import "ShedDetailBottom.h"
#import "ShedDatailCenter.h"
#import "ShedDetailBottomMenu.h"
#import "CommonShed.h"
#import "YYNetRequest.h"

@interface ShedDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, retain) ShedDetailHeaderView *mShedHeader;
@property (nonatomic, retain) ShedDatailCenter *mShedCenter;
@property (nonatomic, retain) ShedDetailBottom *mShedBottom;
@property (nonatomic, retain) ShedDetailBottomMenu *mShedMenu;
@property (nonatomic, retain) YYNetRequest *theRequest;
@property (weak, nonatomic) NSString *dev_id;
@property float startY;
-(void)initViewsWithDatas:(NSDictionary*)model;
-(YYNetRequest *)createRequest;
@end
