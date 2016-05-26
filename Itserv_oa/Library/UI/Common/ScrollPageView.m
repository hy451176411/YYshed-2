//
//  ScrollPageView.m
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "ScrollPageView.h"
#import "HomeViewCell.h"
#import "ECMSContent.h"
@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mNeedUseDelegate = YES;
        [self commInit];
    }
    return self;
}

-(void)initData:(NSArray*)titles{
    [self freshContentTableAtIndex:0];
}


-(void)commInit{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        NSLog(@"ScrollViewFrame:(%f,%f)",self.frame.size.width,self.frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}



#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables withTitles:(NSArray*)titles{
	self.titleArray = titles;
    for (int i = 0; i < aNumerOfTables; i++) {
        CustomTableView *vCustomTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.frame.size.height)];
        vCustomTableView.delegate = self;
        vCustomTableView.dataSource = self;
		//vCustomTableView.model = self.titleArray.[i];
        //为table添加嵌套HeadderView
        [self addLoopScrollowView:vCustomTableView];
        [_scrollView addSubview:vCustomTableView];
        [_contentItems addObject:vCustomTableView];
           }
    [_scrollView setContentSize:CGSizeMake(320 * aNumerOfTables, self.frame.size.height)];
}

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex{
	
    if (_contentItems.count < aIndex) {
        return;
    }
    CustomTableView *vTableContentView =(CustomTableView *)[_contentItems objectAtIndex:aIndex];
	vTableContentView.model =  self.titleArray[aIndex];
	//刷新第几页数据
	[vTableContentView forceToFreshData];
}

#pragma mark 添加HeaderView
-(void)addLoopScrollowView:(CustomTableView *)aTableView {
    //添加一张默认图片
	NSDictionary *dic =@{@"image": [NSString stringWithFormat:@"girl%d",2]};
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dic tag:-1] ;
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 105) delegate:aTableView imageItems:@[item] isAuto:YES];
    aTableView.homeTableView.tableHeaderView = bannerView;
	
    
}

#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(CustomTableView *)aTableContent{

	float length = aTableContent.advArray.count;
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length];
    //添加最后一张图 用于循环
    if (length > 1)
    {
        NSDictionary *dict = [aTableContent.advArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [aTableContent.advArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [aTableContent.advArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    
    SGFocusImageFrame *vFocusFrame = (SGFocusImageFrame *)aTableContent.homeTableView.tableHeaderView;
    [vFocusFrame changeImageViewsContent:itemArray];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (_scrollView.contentOffset.x+320/2.0) / 320;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
//        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
//        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
//        [self moveToTargetPosition:targetX];
    }
  

}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"homeCell";
    HomeViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil] lastObject];
    }
	NSArray *array =aView.tableInfoArray;
	ECMSContent *content =array[aIndexPath.row];
	vCell.title.text = content.title;
	NSString *str = [NSString stringWithFormat:@"%@%@",PIC_URL, content.smallpic];
	//UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:str]]];
	[vCell.headerImageView setOnlineImage:str
						 placeholderImage:[UIImage imageNamed:@"loading_thumb.png"]];
   // vCell.headerImageView.image = image;
    return vCell;
}

#pragma mark CustomTableViewDelegate
-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    HomeViewCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"HomeViewCell" owner:self options:nil] lastObject];
    return vCell.frame.size.height;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
	if ([_delegate respondsToSelector:@selector(YYdidSelectedRowAthIndexPath:IndexPath:FromView:)]) {
		[_delegate YYdidSelectedRowAthIndexPath:aTableView IndexPath:aIndexPath FromView:aView];
	}
}

-(void)refreshData:(void(^)())complete FromView:(CustomTableView *)aView{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		//[self initDatas:aView];
        //改变header显示图片
        [self changeHeaderContentWithCustomTable:aView];
        if (complete) {
            complete();
        }
    });
}

- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView{
   return  aView.reloading;
}


@end
