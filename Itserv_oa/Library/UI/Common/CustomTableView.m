//
//  CustomTableView.m
//  ShowProduct
//
//  Created by klbest1 on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "CustomTableView.h"
#import "LoadMoreCell.h"

@implementation CustomTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (_homeTableView == nil) {
            _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            _homeTableView.delegate = self;
            _homeTableView.dataSource = self;
            [_homeTableView setBackgroundColor:[UIColor clearColor]];
        }
        if (_tableInfoArray == Nil) {
            _tableInfoArray = [[NSMutableArray alloc] init];
        }
        [self addSubview:_homeTableView];
        [self createRefreshHeaderView];
    }
    return self;
}

#pragma mark 创建下拉刷新Header
-(void)createRefreshHeaderView{
    
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:_homeTableView.frame];
		view.delegate = self;
		[self insertSubview:view belowSubview:_homeTableView];
		_refreshHeaderView = view;
		
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
}

#pragma mark 其他辅助功能
#pragma mark 强制列表刷新
//强制刷新第几页
-(void)forceToFreshData{
    [_homeTableView setContentOffset:CGPointMake(_homeTableView.contentOffset.x,  - 66) animated:YES];
    double delayInSeconds = .2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_refreshHeaderView forceToRefresh:_homeTableView];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_delegate respondsToSelector:@selector(numberOfRowsInTableView:InSection:FromView:)]) {
       NSInteger vRows = [_dataSource numberOfRowsInTableView:tableView InSection:section FromView:self];
        mRowCount = vRows;
        return vRows + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(heightForRowAthIndexPath:IndexPath:FromView:)]) {
        float vRowHeight = [_delegate heightForRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
        return vRowHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vMoreCellIdentify = @"loadMoreCell";
    if (indexPath.row == mRowCount) {
        LoadMoreCell *vCell = [tableView dequeueReusableCellWithIdentifier:vMoreCellIdentify];
        if (vCell == Nil) {
            vCell = [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreCell" owner:self options:Nil] lastObject];
        }
        
        return vCell;
    }else{
        if ([_dataSource respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
            UITableViewCell *vCell = [_dataSource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
            return vCell;
        }
    }
    return Nil;
}
//如果是最后一行表示加载更多
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == mRowCount) {
		if (self.lastCount<PAGECOUNT) {
			[SBPublicAlert showMBProgressHUD:@"没有数据了" andWhereView:self hiddenTime:kHiddenAlertTime];
		}else{
			[self loaddata];
		}
    }else{
        if ([_delegate respondsToSelector:@selector(didSelectedRowAthIndexPath:IndexPath: FromView:)]) {
            [_delegate didSelectedRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
        }
    }
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
	_reloading = YES;
	self.isRefresh = YES;
	[self initDatas];
}
-(void)reloadBack{
	if ([_delegate respondsToSelector:@selector(refreshData: FromView:)]) {
		[_delegate refreshData:^{
			[self doneLoadingTableViewData];
		} FromView:self];
	}else{
		[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	}
}
- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.homeTableView];
    [self.homeTableView reloadData];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%s \n click===>%@",__FUNCTION__,item.title);
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
}

-(void)initDatas{
	Column *column = self.model;
	self.start = 0;
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
	[self.theRequest getContentList:self.model.ID withStart:self.start withLimit:PAGECOUNT];
}
-(void)loaddata{
	[self.theRequest getContentList:self.model.ID withStart:self.start withLimit:PAGECOUNT];
}
#pragma mark 请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	if (tag == YYShed_getContentList) {
		if (self.isRefresh) {
			self.isRefresh = NO;
			self.tableInfoArray = [[NSMutableArray alloc]init];
			NSDictionary *funcdata = [model objectForKey:@"funcdata"];
			if (funcdata) {
				NSArray *list = [funcdata objectForKey:@"list"];
				self.lastCount = list.count;
				self.start = self.start + list.count;
				for (int i=0; i<list.count; i++) {
					ECMSContent *content = [[ECMSContent alloc]init];
					NSDictionary *data = list[i];
					content.title = [data objectForKey:@"title"];
					content.ID = [data objectForKey:@"id"];
					content.smallpic = [data objectForKey:@"smallpic"];
					content.content = [data objectForKey:@"content"];
					[self.tableInfoArray addObject:content];
				}
			}
		}else{
			//不是第一次进来，也不是手动刷新，加载更多数据
			NSDictionary *funcdata = [model objectForKey:@"funcdata"];
			if (funcdata) {
				NSArray *list = [funcdata objectForKey:@"list"];
				self.lastCount = list.count;
				self.start = self.start + list.count;
				for (int i=0; i<list.count; i++) {
					ECMSContent *content = [[ECMSContent alloc]init];
					NSDictionary *data = list[i];
					content.title = [data objectForKey:@"title"];
					content.ID = [data objectForKey:@"id"];
					content.smallpic = [data objectForKey:@"smallpic"];
					content.content = [data objectForKey:@"content"];
					[self.tableInfoArray addObject:content];
				}
			}
		}
	}
	[self reloadBack];
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	NSLog(@"请求超时");
	[SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
	[SBPublicAlert showMBProgressHUD:message andWhereView:self hiddenTime:kHiddenAlertTime];
}
@end
