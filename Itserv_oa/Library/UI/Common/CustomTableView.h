//
//  CustomTableView.h
//  ShowProduct
//
//  Created by klbest1 on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "Column.h"
#import "ECMSContent.h"
#import "CommonShed.h"

@class CustomTableView;
@protocol CustomTableViewDelegate <NSObject>
@required;
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView;
-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView;
-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView;
-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView;
@optional
//- (void)tableViewWillBeginDragging:(UIScrollView *)scrollView;
//- (void)tableViewDidScroll:(UIScrollView *)scrollView;
////- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView;
@end

@protocol CustomTableViewDataSource <NSObject>
@required;
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView;
-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView;

@end

@interface CustomTableView : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,SGFocusImageFrameDelegate,YYNetRequestDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    NSInteger     mRowCount;
}
@property NSInteger start;//起始条数
@property NSInteger lastCount;//最后一页有多少条数据
@property (nonatomic,assign) BOOL reloading;
@property (nonatomic, retain) YYNetRequest *theRequest;
@property (nonatomic,retain) UITableView *homeTableView;
@property (nonatomic,strong) NSMutableArray *tableInfoArray;//table的数据列表
@property (nonatomic,strong) NSMutableArray *advArray;//table广告数据
@property (nonatomic,assign) id<CustomTableViewDataSource> dataSource;
@property (nonatomic,assign) id<CustomTableViewDelegate>  delegate;
@property (nonatomic,strong) Column  *model;
- (void)reloadTableViewDataSource;
#pragma mark 强制列表刷新
-(void)forceToFreshData;
@property Boolean isRefresh;
@property Boolean adverLoadOver;
@end
