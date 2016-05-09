//
//  HomeViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-9.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "HomeViewController.h"
#import "ShowWebViewController.h"
#import "MattersCell.h"
#import "RootViewController.h"

@interface HomeViewController ()
{
    NSMutableArray *_muArrCtrl;
    //待办
    NSInteger _currentPage;
    NSInteger _totalPage;
    //待阅
    NSInteger _currentPageDo;
    NSInteger _totalPageDo;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isBackBtn = NO;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strTitle = @"待办事宜";
    
    [self loadTableViewWithRect:CGRectMake(0, _heightTop, ScreenWidth, ScreenHeight - ToolBarHeight) style:UITableViewStylePlain];
    
    _muArrCtrl = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [_muArrCtrl addObject:[NSMutableArray array]];
    }
    
    _currentPage = kStartPage;
    _totalPage = 0;
    
    _currentPageDo = kStartPage;
    _totalPageDo = 0;
    
    _type = 0;
    
    [self sendRequest];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[RootViewController getRootCtrl] btnWithTag:1 select:YES];
    [self getData];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    self.strTitle = (type == 0) ? @"待办事宜" : @"待阅事宜";
    
    [self sendRequest];
}

#pragma mark 发送请求
- (void)sendRequest
{
    NSArray *arr = _muArrCtrl[_type];
    if (arr.count > 0) {//有数据
        [_pullTableView reloadData];
        return;
    }
    [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];
    if (_type == 0) {//待办
        [self.theRequest netRequestNeedDealListStar:_currentPage dotype:_type size:PageSize];
    } else {//待阅
        [self.theRequest netRequestNeedDealListStar:_currentPageDo dotype:_type size:PageSize];
    }

}

#pragma mark NetRequestDelegate
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    if (NeedDealList == tag) {//待办
        [SBPublicAlert hideMBprogressHUD:self.view];
        NSArray *arr = model[@"list"];
        NSMutableArray *muArr = _muArrCtrl[0];
        if (_currentPage == kStartPage) {
            [muArr removeAllObjects];
        }
        _totalPage = [model[@"tcount"] integerValue];
        [muArr addObjectsFromArray:arr];
        if (muArr.count == 0) {
            [SBPublicAlert showMBProgressHUD:@"没有数据" andWhereView:self.view hiddenTime:kHiddenAlertTime];
        }
        [self updateTableViewCount:muArr.count pageSize:_totalPage];
    } else if (NeedDealListOne == tag) {//待阅
        [SBPublicAlert hideMBprogressHUD:self.view];
        
        NSArray *arr = model[@"list"];
        NSMutableArray *muArr = _muArrCtrl[1];
        if (_currentPageDo == kStartPage) {
            
            [muArr removeAllObjects];
        }
        _totalPageDo = [model[@"tcount"] integerValue];
        [muArr addObjectsFromArray:arr];
        
        if (muArr.count == 0) {
            [SBPublicAlert showMBProgressHUD:@"没有数据" andWhereView:self.view hiddenTime:kHiddenAlertTime];
        }
        [self updateTableViewCount:muArr.count pageSize:_totalPageDo];
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


- (void)getData
{
    if (_type == 0) {//待办
        _currentPage = kStartPage;
        [self.theRequest netRequestNeedDealListStar:_currentPage dotype:_type size:PageSize];
        
    } else {//待阅
        _currentPageDo = kStartPage;
        [self.theRequest netRequestNeedDealListStar:_currentPageDo dotype:_type size:PageSize];
    }
}

- (void)nextPage
{
    if (_type == 0) {//待办
        _currentPage++;
        [self.theRequest netRequestNeedDealListStar:_currentPage dotype:_type size:PageSize];
        
    } else {//待阅
        _currentPageDo++;
        [self.theRequest netRequestNeedDealListStar:_currentPageDo dotype:_type size:PageSize];
    }
}

#pragma mark UITableViewDetegate
//有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//每个section中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _muArrCtrl[_type];
    if (arr.count == 0) {
        return 0;
    }
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = _muArrCtrl[_type];
    if (arr.count == 0) {
        return 0;
    }
    return [MattersCell cellHeight:arr[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MattersCell";
    MattersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [MattersCell loadFromXibWithOwner:self];
    }
    cell.backgroundColor = ClearColor;
    NSArray *arr = _muArrCtrl[_type];
    if (arr.count > 0) {
        [cell loadData:arr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    
    [[RootViewController getRootCtrl] hiddenAllTableViewMenu];
    
    if (tableView == _pullTableView) {//首页列表
        ShowWebViewController *ctrl = [[ShowWebViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ShowWebViewController"] bundle:nil];
        NSArray *arr = _muArrCtrl[_type];
        NSDictionary *dic = arr[index];
        NSString *url = dic[@"url"];
        ctrl.strUrl = url;
        ctrl.strTopTitle = self.strTitle;
        [[AppDelegate getNav] pushViewController:ctrl animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
