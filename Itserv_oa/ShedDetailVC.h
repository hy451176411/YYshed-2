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

@interface ShedDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic, retain) ShedDetailHeaderView *mShedDetailHeader;
@end
