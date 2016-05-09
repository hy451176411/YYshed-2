//
//  BaseViewController.h
//  Hunbohui
//
//  Created by xiexianhui on 14-5-6.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetRequest.h"
#import "PullToRefreshTableView.h"

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetRequestDelegate>
{
    UIView *_viewTop;//顶部navbar
    
    BOOL _isBackBtn;//是否有左边返回按钮  //默认是有左边返回按钮
    BOOL _isRightBtn;//是否有右边按钮    //默认是没有右边按钮
    UIButton *_btnBack;
    UIButton *_btnRight;
    
    UILabel *_labelTitle;//标题
    
    CGFloat _heightTop;//顶部bar的高度
    
    PullToRefreshTableView *_pullTableView;//带有上拉加载，下拉刷新
    BOOL _isAddTap;//是否添加手势
    
    IBOutlet UIView *_viewContentBg;

}

@property (nonatomic, retain) NetRequest *theRequest;
@property (nonatomic, retain) NSString *strTitle;

//加载tableView
- (void)loadTableViewWithRect:(CGRect)theRect style:(UITableViewStyle)style;

//返回按钮事件
- (void)btnBackClicked:(UIButton *)sender;

//右边按钮事件
- (void)btnRightClicked:(UIButton *)sender;

/*更换返回按钮的图片   文字   
 arrName中包含btn多种状态的图片 UIControlStateNormal UIControlStateHighlighted UIControlStateSelected
 */
- (void)btnReplaceBackWithImgNameArr:(NSArray *)arrName title:(NSString *)theTitle;

//更换右边按钮的图片  文字
- (void)btnReplaceRightWithImgNameArr:(NSArray *)arrName title:(NSString *)theTitle;

//刷新
-(void)getData;
// 加载
- (void)nextPage;

- (void)pageMinusOne;

- (void)updateTableViewCount:(NSInteger)theCount pageSize:(NSInteger)size;
@end
