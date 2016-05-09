//
//  SendReceiveViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "SendReceiveViewController.h"
#import "FileMessageCell.h"
#import "ProcessFileViewController.h"

@interface SendReceiveViewController ()
{
    IBOutlet UITableView *_tableViewFile;
    NSMutableArray *_muArrDic;
}

@end

@implementation SendReceiveViewController

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
    NSString *strName = _dicData[@"title"];
    self.strTitle = strName;
    
    _tableViewFile.top = _heightTop;
    _tableViewFile.height = ScreenHeight - _heightTop;
    
    _muArrDic = [[NSMutableArray alloc] init];
    
    [self.theRequest netRequestgetSubMenuListMenuid:_dicData[@"moduleid"]];
    [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark NetRequestDelegate
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    [SBPublicAlert hideMBprogressHUD:self.view];
    NSArray *arr = model[@"list"];
    [_muArrDic addObjectsFromArray:arr];
    [_tableViewFile reloadData];
    if (_muArrDic.count == 0) {
        [SBPublicAlert showMBProgressHUD:@"没有数据" andWhereView:self.view hiddenTime:kHiddenAlertTime];
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
    return _muArrDic.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    FileMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [FileMessageCell loadFromXibWithOwner:self];
    }
    cell.backgroundColor = ClearColor;

    NSDictionary *dic = _muArrDic[indexPath.row];
    [cell loadData:dic withIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    NSString *strCtrlName = [AppDelegate strCtrlName:@"ProcessFileViewController"];
    ProcessFileViewController *ctrl = [[ProcessFileViewController alloc] initWithNibName:strCtrlName bundle:nil];
    ctrl.strTitleSuper = _dicData[@"title"];
    ctrl.dic = _muArrDic[index];
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
