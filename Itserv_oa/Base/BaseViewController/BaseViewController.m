//
//  BaseViewController.m
//  Hunbohui
//
//  Created by xiexianhui on 14-5-6.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "BaseViewController.h"
#import "RootViewController.h"

const CGFloat viewHeight = 44;

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isBackBtn = YES;
        _isRightBtn = NO;
        _isAddTap = YES;
    }
    return self;
}

- (void)dealloc
{
    if (_pullTableView) {
        [_pullTableView release];
        _pullTableView = nil;
    }
    _theRequest.delegate = nil;
    [_theRequest release];
    [_strTitle release];
    _strTitle = nil;
    [_viewTop release];
    _viewTop = nil;
    [_labelTitle release];
    _labelTitle = nil;
    [super dealloc];
}

#pragma mark 重写strTitle的set方法
- (void)setStrTitle:(NSString *)strTitle
{
    if (_strTitle != strTitle) {
        [_strTitle release];
        _strTitle = [strTitle retain];
    }
    
    _labelTitle.text = _strTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (kIsIos7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
    
    self.view.backgroundColor = RGBFromColor(0xf4f4f4);
    
    //顶部  navbar
    _viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    _viewTop.backgroundColor = RGBFromColor(0x43B3E3);
//    [_viewTop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top"]]];
    [self.view addSubview:_viewTop];
    
    _heightTop = (CGFloat)NavBarHeight;
    
    //标题
    _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, _viewTop.frame.size.height - viewHeight, ScreenWidth - 2*50, viewHeight)];
    _labelTitle.backgroundColor = ClearColor;
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.textColor = [UIColor whiteColor];
//    [_labelTitle setFont:[UIFont fontWithName:@"Thonburi-Bold" size:23]];
        [_labelTitle setFont:SystemFontOfSize(20)];
    [_viewTop addSubview:_labelTitle];
    //有左边的返回按钮
    if (_isBackBtn) {
        [self loadBackBtn];
    }
    
    //有右边的按钮
    if (_isRightBtn) {
        [self loadRightBtn];
    }
    
    if (_isAddTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearMenu)];
        tap.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tap];
    }
    
    _viewContentBg.backgroundColor = [UIColor clearColor];
    _viewContentBg.top = _heightTop;
    _viewContentBg.height = ScreenHeight - _heightTop;
    _viewContentBg.autoresizesSubviews = NO;
    _viewContentBg.autoresizingMask = UIViewAutoresizingNone;
    _viewContentBg.backgroundColor = RGBFromColor(0xf4f4f4);
    
	// Do any additional setup after loading the view.
}

#pragma mark 隐藏所有菜单
- (void)clearMenu
{
    [[RootViewController getRootCtrl] hiddenAllTableViewMenu];
}

#pragma mark 加载返回按钮
- (void)loadBackBtn
{
    CGFloat height = viewHeight;
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBack.frame = CGRectMake(0, _viewTop.frame.size.height - height, 65, height);
    _btnBack.backgroundColor = [UIColor clearColor];
    _btnBack.titleLabel.font = SystemFontOfSize(16);
    [_btnBack setImage:CachedImage(@"back_normal") forState:UIControlStateNormal];
    [_btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    _btnBack.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);//上左下右
    _btnBack.autoresizesSubviews = YES;
    _btnBack.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [_viewTop addSubview:_btnBack];
}

#pragma mark UIButton返回按钮事件
- (void)btnBackClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 加载右边按钮
- (void)loadRightBtn
{
    CGFloat width = 50;
    _btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(ScreenWidth - width, _viewTop.frame.size.height - viewHeight, width, 44);
//    [_btnBack setImage:ImageWithPath(PathForPNGResource(@"top_ico_home")) forState:UIControlStateNormal];
    [_btnRight.titleLabel setFont:SystemFontOfSize(13)];
    _btnRight.backgroundColor = ClearColor;
    [_btnRight addTarget:self action:@selector(btnRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_viewTop addSubview:_btnRight];
}


#pragma mark UIButton右边按钮事件
- (void)btnRightClicked:(UIButton *)sender
{
    POBJECT(@"右边");
}

#pragma mark 更换返回按钮的图片  文字
- (void)btnReplaceBackWithImgNameArr:(NSArray *)arrName title:(NSString *)theTitle
{
    if (_btnBack) {
        if ([arrName count] != 0) {
            NSString *strNormal = arrName[0];
            [_btnBack setImage:ImageWithPath(PathForPNGResource(strNormal)) forState:UIControlStateNormal];
            if (arrName.count >= 2) {
                  NSString *strHighlighted = arrName[1];
                    [_btnBack setImage:ImageWithPath(PathForPNGResource(strHighlighted)) forState:UIControlStateHighlighted];
            }
        }
        if (theTitle.length != 0) {//有标题
            [_btnBack setTitle:theTitle forState:UIControlStateNormal];
        }
        
    }
}

#pragma mark 更换右边按钮的图片  文字
- (void)btnReplaceRightWithImgNameArr:(NSArray *)arrName title:(NSString *)theTitle
{
    if (_btnRight) {
        if ([arrName count] != 0) {
            NSString *strNormal = arrName[0];
            UIImage *img = ImageWithPath(PathForPNGResource(strNormal));
            
            [_btnRight setImage:img forState:UIControlStateNormal];

            if (arrName.count >= 2) {
                NSString *strHighlighted = arrName[1];
                [_btnRight setImage:ImageWithPath(PathForPNGResource(strHighlighted)) forState:UIControlStateHighlighted];
            }
        }
        if (theTitle.length != 0) {//有标题
            [_btnRight setTitle:theTitle forState:UIControlStateNormal];
        }
    }
}

#pragma mark  加载tableView
- (void)loadTableViewWithRect:(CGRect)theRect style:(UITableViewStyle)style
{
    _pullTableView = [[PullToRefreshTableView alloc] initWithFrame:theRect style:style];
    if (style == UITableViewStyleGrouped) {
        [_pullTableView setBackgroundView:nil];
    }
//    [_pullTableView setBackgroundView:[[UIView alloc] init]];
    
    [_pullTableView setBackgroundColor:[UIColor clearColor]];
    _pullTableView.delegate = self;
    _pullTableView.dataSource = self;
    [self.view addSubview:_pullTableView];
    _pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pullTableView.isCloseFooter = YES;
//    _pullTableView.isCloseHeader = YES;
}

#pragma mark 刷新的代理方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger returnKey = [_pullTableView tableViewDidEndDragging];
    if (returnKey != k_RETURN_DO_NOTHING) {
        NSString * key = [NSString stringWithFormat:@"%d", returnKey];
        [self updateThread:key];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_pullTableView tableViewDidDragging];
}

- (void)updateTableViewCount:(NSInteger)theCount pageSize:(NSInteger)size
{
    BOOL status = NO;
    NSInteger totalCount = size;
    if (size == 0) {
        totalCount = (int)PageSize;
    } else if (size == -1) {//网络问题失败
        status = YES;
    }
    
    if (theCount < totalCount) {//小于
        status = YES;
    }
    if (theCount != 0) {
        _pullTableView.isCloseFooter = !status;
    }
    
    if (status) {//还有数据
        // 一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        [_pullTableView reloadData:NO];
    } else {//没有数据
        //  一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
        [_pullTableView reloadData:YES];
    }
}


#pragma mark 刷新
-(void)getData
{
    
}

#pragma mark 加载
- (void)nextPage
{
    
}

- (void)updateThread:(NSString *)returnKey{
    switch ([returnKey intValue]) {
        case k_RETURN_REFRESH:
            //            [data removeAllObjects];
            [self getData];
            break;
        case k_RETURN_LOADMORE:
            [self nextPage];
            break;
        default:
            break;
    }
}


- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
    if (_pullTableView) {
        [self updateTableViewCount:0 pageSize:0];
    }
    [SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    [self pageMinusOne];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
    if (message.length == 0) {
        message = @"请求失败";
    }
    if (_pullTableView) {
        [self updateTableViewCount:0 pageSize:0];
    }
    
    [SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
    [self pageMinusOne];
}

- (void)pageMinusOne
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
