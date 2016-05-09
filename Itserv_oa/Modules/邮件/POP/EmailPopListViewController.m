//
//  EmailPopListViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-3.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "EmailPopListViewController.h"
#import "EmailCell.h"
#import "EmailContentViewController.h"
#import "RootViewController.h"
#import "SendEmailViewController.h"
#import "SendEmailPOPViewController.h"
#import "RADataObject.h"
#import "EmailPopContentViewController.h"

@interface EmailPopListViewController ()
{
    NSMutableArray *_muArrData;
    NSInteger _currentPage;
    NSInteger _totalPage;
    BOOL _isPop3;
}

@end

@implementation EmailPopListViewController

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
    
    _isPop3 = [AppDelegate isPop3];
    
    switch (_type) {
        case 0:{
            self.strTitle = @"收件箱";
        }break;
        case 1:{
            self.strTitle = @"发件箱";
        }break;
        case 2:{
            self.strTitle = @"草稿箱";
        }break;
        default:
            break;
    }
    
    [self loadTableViewWithRect:CGRectMake(0, _heightTop, ScreenWidth, ScreenHeight - _heightTop - ToolBarHeight) style:UITableViewStylePlain];
    
    _muArrData = [[NSMutableArray alloc] init];
    _currentPage = kStartPage;
    _totalPage = 0;
    
    [self sendRequest];

    // Do any additional setup after loading the view from its nib.
}

- (void)refreshSendMailWithArr:(NSArray *)arr
{
    [_muArrData removeAllObjects];
    [_muArrData addObjectsFromArray:arr];
    [self updateTableViewCount:_muArrData.count pageSize:_muArrData.count];
}

- (void)sendRequest
{
    if (_isPop3) {
        
        if (_type == 2) {//草稿箱
            return;
        } else if (_type == 1) {//发件箱
            
            [self refreshSendMailWithArr:[SaveData getSendEmailArr]];
            return;
        }
        [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];

        __block EmailPopListViewController *ctrl = self;
        
        [[MailMessage sharedInstance] arrEmailMessage:^(NSArray *arrMessage){
            [SBPublicAlert hideMBprogressHUD:self.view];
            [ctrl refreshDataWithArr:arrMessage];
        }];
    } else {
        [self.theRequest netRequestMailListStart:_currentPage type:_type];
    }
}

- (void)refreshDataWithArr:(NSArray *)arr
{
    if (_currentPage == kStartPage) {
        [_muArrData removeAllObjects];
    }
    
    [_muArrData addObjectsFromArray:arr];
    [self updateTableViewCount:_muArrData.count pageSize:_muArrData.count];
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
    NSInteger tagRequest = MailList + _type;

    if (tag == tagRequest) {
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
    } else if (tag == DeleteMail) {//删除邮件成功
        if ([model isKindOfClass:[NSDictionary class]]) {
            [SBPublicAlert showMBProgressHUD:model[@"resultinfo"] andWhereView:self.view hiddenTime:kHiddenAlertTime];
        }
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
    
    if (_isPop3) {
        if (_type == 0) {//收件箱
            [cell loadMailCore:_muArrData[indexPath.row] type:_type];
        } else {//发件箱
            [cell loadSendMail:_muArrData[indexPath.row]];
        }
    } else {
        [cell loadData:_muArrData[indexPath.row] type:_type];
    }
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
        
        if ([AppDelegate isNotReachable]) {
            
            
            
            if (_isPop3) {
                if (_type == 1) {//发件箱
                    [SaveData deleteSendMailIndex:indexPath.row];
                    
                    NSInteger index =  indexPath.row;
                    [_muArrData removeObjectAtIndex:index];
                    [_pullTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    return;
                }
                __block EmailPopListViewController *ctrl = self;
                NSInteger index = _muArrData.count-indexPath.row;
                [[MailMessage sharedInstance] deleteEmailIndex:index withIsSuccess:^(BOOL success,int row){
                    if (success) {
                        [ctrl deleteRefreshTableWithRow:row];
                    }
                }];

            } else {
//                [self.theRequest netRequestDeleteMailID:dic[@"id"]];
            }
        }
    }
}

- (void)deleteRefreshTableWithRow:(int)row
{
    NSInteger index =  _muArrData.count - row;
    [_muArrData removeObjectAtIndex:index];
    [_pullTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isPop3) {
        
        if (_type == 2 ) {//草稿箱
            SendEmailPOPViewController *ctrl = [[SendEmailPOPViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailPOPViewController"] bundle:nil];
            ctrl.type = SendMail;
//            ctrl.dicDraft = dic;
            [[AppDelegate getNav] pushViewController:ctrl animated:YES];
            return;
        }
            
        if (_type == 1) {//发件箱

            EmailPopContentViewController *ctrl = [[EmailPopContentViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailPopContentViewController"] bundle:nil];
            ctrl.dicSendEmail = _muArrData[indexPath.row];
            [[AppDelegate getNav] pushViewController:ctrl animated:YES];

            return;
        }
        
        MCOMessageParser *parse = _muArrData[indexPath.row];
        EmailPopContentViewController *ctrl = [[EmailPopContentViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailPopContentViewController"] bundle:nil];
        ctrl.messageParser = parse;
        [[AppDelegate getNav] pushViewController:ctrl animated:YES];
        
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_muArrData[indexPath.row]];
    BOOL isNew = [dic[@"isnew"] boolValue];
    if (isNew) {//未读
        isNew = NO;
        [dic setObject:@"0" forKey:@"isnew"];
        [_muArrData replaceObjectAtIndex:indexPath.row withObject:dic];
    }
    [_pullTableView reloadData];

    if (_type == 2) {//草稿箱
        SendEmailViewController *ctrl = [[SendEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailViewController"] bundle:nil];
        ctrl.type = SendMail;
        ctrl.dicDraft = dic;
        [[AppDelegate getNav] pushViewController:ctrl animated:YES];
        return;
    }
    EmailContentViewController *ctrl = [[EmailContentViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailContentViewController"] bundle:nil];
    ctrl.dicEmail = dic;
    [[AppDelegate getNav] pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
