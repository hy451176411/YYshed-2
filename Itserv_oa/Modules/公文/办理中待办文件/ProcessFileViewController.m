//
//  ProcessFileViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-2.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "ProcessFileViewController.h"
#import "ProcessFileCell.h"
#import "ShowWebViewController.h"

@interface ProcessFileViewController ()
{
    NSMutableArray *_muArrData;
    NSInteger _currentPage;
    NSInteger _totalPage;
}
@end

@implementation ProcessFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *strName = [NSString stringWithFormat:@"%@-%@",_strTitleSuper,_dic[@"title"]];
    self.strTitle = strName;
    
    _muArrData = [[NSMutableArray alloc] init];

    [self loadTableViewWithRect:CGRectMake(0, _heightTop, ScreenWidth, ScreenHeight - _heightTop - ToolBarHeight) style:UITableViewStylePlain];
    
    
    _currentPage = kStartPage;
    
    _totalPage = 0;
    [self sendRequestPage];
    [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];

    // Do any additional setup after loading the view from its nib.
}

- (void)sendRequestPage
{
    NSString *strId = _dic[@"moduleid"];
    [self.theRequest netRequestNeedDealListStar:_currentPage moduleid:strId size:PageSize type:_dic[@"type"]];
}

- (void)getData
{
    _currentPage = kStartPage;
    [self sendRequestPage];
}

- (void)nextPage
{
    _currentPage++;
    [self sendRequestPage];
}

- (void)pageMinusOne
{
    if (_currentPage > kStartPage) {
        _currentPage--;
    }
}

#pragma mark NetRequestDelegate
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    [SBPublicAlert hideMBprogressHUD:self.view];
    _totalPage = [model[@"tcount"] integerValue];
    if (_totalPage == 0) {
        [self updateTableViewCount:_muArrData.count pageSize:_totalPage];
        [SBPublicAlert showMBProgressHUD:@"没有数据" andWhereView:self.view hiddenTime:kHiddenAlertTime];
        return;
    }
    if (_currentPage == kStartPage) {//是第一页
        [_muArrData removeAllObjects];
    }
    
    NSArray *arr = model[@"list"];
    [_muArrData addObjectsFromArray:arr];

    [self updateTableViewCount:_muArrData.count pageSize:_totalPage];
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
    return _muArrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ProcessFileCell cellHeight:_muArrData[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ProcessFileCell";
    ProcessFileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [ProcessFileCell loadFromXibWithOwner:self];
    }
    cell.backgroundColor = ClearColor;

    [cell loadData:_muArrData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowWebViewController *ctrl = [[ShowWebViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ShowWebViewController"] bundle:nil];
    NSDictionary *dic = _muArrData[indexPath.row];
    NSString *url = dic[@"url"];
    ctrl.strUrl = url;
    ctrl.strTopTitle = self.strTitle;
    [[AppDelegate getNav] pushViewController:ctrl animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
