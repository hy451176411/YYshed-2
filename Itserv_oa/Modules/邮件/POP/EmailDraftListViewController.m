//
//  EmailDraftListViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-3.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "EmailDraftListViewController.h"
#import "EmailCell.h"
#import "EmailContentViewController.h"
#import "RootViewController.h"
#import "SendEmailViewController.h"
#import "SendEmailPOPViewController.h"

@interface EmailDraftListViewController ()<SendEmailPOPViewDelegate>
{
    NSMutableArray *_muArrData;
    NSInteger _currentPage;
    NSInteger _totalPage;
    BOOL _isPop3;
}

@end

@implementation EmailDraftListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //    [self getData];
    [[RootViewController getRootCtrl] btnWithTag:3 select:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isPop3 = YES;
    self.strTitle = @"草稿箱";
    
    
    [self loadTableViewWithRect:CGRectMake(0, _heightTop, ScreenWidth, ScreenHeight - _heightTop - ToolBarHeight) style:UITableViewStylePlain];
    
    _muArrData = [[NSMutableArray alloc] init];

    [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];

    [self sendRequest];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)sendRequest
{
    //获取本地草稿
    [self refreshDataWithArr:[SaveData getEmailArr]];
}

- (void)refreshDataWithArr:(NSArray *)arr
{
    [_muArrData removeAllObjects];
    [_muArrData addObjectsFromArray:arr];
    [SBPublicAlert hideMBprogressHUD:self.view];
    [self updateTableViewCount:_muArrData.count pageSize:_muArrData.count];
}

- (void)getData
{
    [self sendRequest];
}

- (void)nextPage
{
    [self sendRequest];
}

- (void)pageMinusOne
{
    if (_currentPage > kStartPage) {
        _currentPage--;
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
    return _muArrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EmailCell";
    EmailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [EmailCell loadFromXibWithOwner:self];
        cell.backgroundColor = WhiteColor;
    }
    NSDictionary *dic = _muArrData[indexPath.row];
    
    [cell loadData:dic type:2];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([SaveData deleteEmailIndex:indexPath.row]) {
            [self deleteRefreshTableWithRow:indexPath.row];
        }
    }
}

- (void)deleteRefreshTableWithRow:(int)row
{
    NSInteger index =  row;
    [_muArrData removeObjectAtIndex:index];
    [_pullTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SendEmailPOPViewController *ctrl = [[SendEmailPOPViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailPOPViewController"] bundle:nil];
    ctrl.delegate = self;
    ctrl.type = SendMail;
    NSDictionary *dic = _muArrData[indexPath.row];
    ctrl.index = indexPath.row + 1;
    ctrl.dicDraft = dic;
    [[AppDelegate getNav] pushViewController:ctrl animated:YES];
}

//草稿箱邮件发送后就删除
- (void)sendDraftEmailSuccessIndex:(NSInteger)index
{
    if ([SaveData deleteEmailIndex:index]) {
        [self deleteRefreshTableWithRow:index];
    }
}


- (void)saveDraftEmail
{
    [self getData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
