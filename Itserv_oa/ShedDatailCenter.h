//
//  ShedDatailCenter.h
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
@interface ShedDatailCenter : UIView
+ (instancetype) initCenter:(UIScrollView *) scrollView;
-(void)configDataOfCenter:(id)data;
@end
