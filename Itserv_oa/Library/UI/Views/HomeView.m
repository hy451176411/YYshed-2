//
//  HomeView.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "HomeView.h"
#import "HomeViewCell.h"
#import "Column.h"


#define MENUHEIHT 40

@implementation HomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
    }
    return self;
}
-(void)initViews{
	[self commInit];
}
#pragma mark UI初始化
-(void)commInit{
	vButtonItemArray = [NSMutableArray array];
	for (int i=0; i<self.titles.count; i++) {
		NSNumber *width =[NSNumber numberWithFloat:108];
		Column *column = self.titles[i];
		NSString *title = column.name;
		NSDictionary  *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"normal.png",NOMALKEY,@"select_iPad.png",HEIGHTKEY,width,TITLEWIDTH,title,TITLEKEY,nil];
		[vButtonItemArray addObject:dic];
	}
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, MENUHEIHT) ButtonItems:vButtonItemArray];
        mMenuHriZontal.delegate = self;
    }
    //初始化滑动列表
    if (mScrollPageView == nil) {
        mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT)];
        mScrollPageView.delegate = self;
    }
    [mScrollPageView setContentOfTables:vButtonItemArray.count withTitles:self.titles];
    //默认选中第一个button
    [mMenuHriZontal clickButtonAtIndex:0];
    //-------
    [self addSubview:mScrollPageView];
    [self addSubview:mMenuHriZontal];
}



#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    NSLog(@"第%d个Button点击了",aIndex);
    [mScrollPageView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSLog(@"CurrentPage:%d",aPage);
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
//    if (aPage == 3) {
        //刷新当页数据
        [mScrollPageView freshContentTableAtIndex:aPage];
//    }
}
-(void)YYdidSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
	if ([_delegate respondsToSelector:@selector(YYdidSelectedRowAthIndexPath:IndexPath:FromView:)] ) {
		[_delegate YYdidSelectedRowAthIndexPath:aTableView IndexPath:aIndexPath FromView:aView];
	}
}
@end
