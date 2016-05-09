//
//  ToReadViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "ToReadViewController.h"
#import "MattersCell.h"
#import "ShowWebViewController.h"

@interface ToReadViewController ()
{
    NSMutableArray *_muArrData;
    NSInteger _currentPage;
    NSInteger _totalPage;
}
@end

@implementation ToReadViewController

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
    NSString *strName = @"";
    switch (_type) {
        case 0:
            strName = @"待办事宜";
            break;
        case 1:
            strName = @"待阅事宜";
            break;
        case 2:
            strName = @"已办事宜";
            break;
        case 3:
            strName = @"已阅事宜";
            break;
        default:
            break;
    }
    self.strTitle = strName;
    
    [self loadTableViewWithRect:CGRectMake(0, _heightTop, ScreenWidth, ScreenHeight - _heightTop) style:UITableViewStylePlain];
    
    _muArrData = [[NSMutableArray alloc] init];
    
    _currentPage = kStartPage;
    
    _totalPage = 0;

    [self sendRequest];
    [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];

    // Do any additional setup after loading the view from its nib.
}

- (void)sendRequest
{
    [self.theRequest netRequestNeedDealListStar:_currentPage dotype:_type size:PageSize];
}

- (void)getData
{
    _currentPage = kStartPage;
    [self sendRequest];
}

- (void)nextPage
{
    _currentPage++;
    [self sendRequest];
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

    if (_currentPage == kStartPage) {//是第一页
        [_muArrData removeAllObjects];
    }
    NSArray *arr = model[@"list"];
    [_muArrData addObjectsFromArray:arr];
    
    if (_muArrData.count == 0) {
        [SBPublicAlert showMBProgressHUD:@"没有数据" andWhereView:self.view hiddenTime:kHiddenAlertTime];
    }
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
    return [MattersCell cellHeight:_muArrData[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MattersCell";
    MattersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [MattersCell loadFromXibWithOwner:self];
        cell.backgroundColor = ClearColor;
    }
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
