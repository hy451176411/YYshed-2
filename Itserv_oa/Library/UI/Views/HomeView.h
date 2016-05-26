//
//  HomeView.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuHrizontal.h"
#import "ScrollPageView.h"
#import "AboutMeVC.h"
@protocol HomeViewDelegate <NSObject>
-(void)YYdidSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView;
@end

@interface HomeView : UIView<MenuHrizontalDelegate,ScrollPageViewDelegate>
{
    MenuHrizontal *mMenuHriZontal;
    ScrollPageView *mScrollPageView;
	NSMutableArray *vButtonItemArray;
}
@property (nonatomic,assign) id<HomeViewDelegate> delegate;
@property (nonatomic,strong)NSArray *titles;
-(void)initViews;
@end
