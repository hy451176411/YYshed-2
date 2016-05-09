//
//  RootViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-18.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PushMessageCell.h"
#import "ToReadViewController.h"
#import "SendReceiveViewController.h"
#import "IntegratedQueryViewController.h"
#import "ContactsViewController.h"
#import "EmailListViewController.h"
#import "MattersCell.h"
#import "SendEmailViewController.h"
#import "ShowWebViewController.h"
#import "HomeViewController.h"
#import "BindingEmailViewController.h"
#import "SendEmailPOPViewController.h"
#import "EmailDraftListViewController.h"
#import "EmailPopListViewController.h"
#import "EmailContactsViewController.h"

@interface RootViewController ()<SendEmailViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_muArrCtrl;
    IBOutlet UIView *_viewTool;//底部按钮
    IBOutlet PullToRefreshTableView *_tableViewHome;
    int _currentTag;//当前点击的按钮
    IBOutlet UITableView *_tableViewSmallOne;//显示栏目
    IBOutlet UITableView *_tableViewSmallTwo;//显示栏目
    IBOutlet UITableView *_tableViewSmallThree;//显示栏目
    IBOutlet UITableView *_tableViewSmallFour;//显示栏目

    NSMutableArray *_muArrMenu;//
    //待办
    NSInteger _currentPage;
    NSInteger _totalPage;
    //待阅
    NSInteger _currentPageDo;
    NSInteger _totalPageDo;
    
    NSInteger _heightMenuCell;//菜单cell的高度
    NSInteger _widthMenuCell;//菜单cell的宽度
    CGFloat _fontSize;//菜单cell字体大小
    
    NSInteger _typeDo;//0待办  1待阅
    
    UINavigationController *_nav;
    HomeViewController *_homeCtrl;
}
@property (nonatomic, retain) NSString *strUpdateUrl;

@end

static RootViewController *rootCtrl = nil;

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isBackBtn = NO;
        _isAddTap = NO;
    }
    return self;
}

+ (RootViewController *)getRootCtrl
{
    return rootCtrl;
}

- (void)hiddenAllTableViewMenu
{
    [self hiddenTableView:_tableViewSmallOne];
    [self hiddenTableView:_tableViewSmallTwo];
    [self hiddenTableView:_tableViewSmallThree];
    [self hiddenTableView:_tableViewSmallFour];
}

- (void)loadTableViewLayer:(UITableView *)tableV
{
    tableV.hidden = YES;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableV.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
//    tableV.layer.borderWidth = 1;
//    tableV.layer.shadowColor = [UIColor grayColor].CGColor;
//    tableV.layer.shadowOffset = CGSizeMake(0, 2);
    
    NSInteger num = [_muArrMenu[tableV.tag - 10 - 1] count];
    CGFloat height = num * _heightMenuCell;
    tableV.height = height;
    tableV.top = ScreenHeight;
    [self.view bringSubviewToFront:tableV];
    [self.view bringSubviewToFront:_viewTool];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTableViewLayer:_tableViewSmallOne];
    [self loadTableViewLayer:_tableViewSmallTwo];
    [self loadTableViewLayer:_tableViewSmallThree];
    [self loadTableViewLayer:_tableViewSmallFour];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _heightMenuCell = DevicePhone ? 44 : 70;
    _widthMenuCell = DevicePhone ? 80 : 192;
    _fontSize = DevicePhone ? 16 : 30;
    rootCtrl = self;

    _viewTop.hidden = YES;
    
//    [self loadTableViewWithRect:CGRectMake(0, _heightTop, ScreenWidth, ScreenHeight - _heightTop - ToolBarHeight) style:UITableViewStylePlain];
    
    _currentTag = 1;
    
    _muArrCtrl = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [_muArrCtrl addObject:[NSMutableArray array]];
    }
    
    _muArrMenu = [[NSMutableArray alloc] init];
    [_muArrMenu addObject:@[@"待阅事宜",@"待办事宜"]];//个人事务
    [_muArrMenu addObject:[NSMutableArray array]];//公文
    [_muArrMenu addObject:@[@"发邮件",@"收件箱",@"发件箱",@"草稿箱"]];//邮件
    
    if ([AppDelegate isPop3]) {
        [_muArrMenu addObject:@[@"绑定邮箱",@"已阅事宜",@"已办事宜",@"综合查询",@"通讯录",@"注销"]];//更多
    } else {
        [_muArrMenu addObject:@[@"已阅事宜",@"已办事宜",@"综合查询",@"通讯录",@"注销"]];//更多
    }
    
    [self.view bringSubviewToFront:_viewTool];
    
    [self loadCtrl];
    
    if (1) {//没有登录的时候
        [self loadLogin:YES];
    } else {//已经登录后
        [self loadLoginSuccessData];
    }
    
    
    [self.theRequest netRequestVersion];
    
    _currentPage = kStartPage;
    _totalPage = 0;
    
    _currentPageDo = kStartPage;
    _totalPageDo = 0;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 设置按钮的状态
- (void)btnWithTag:(int)tag select:(BOOL)status
{
    UIButton *btn = (UIButton *)[_viewTool viewWithTag:1];
    btn.selected = NO;
    btn = (UIButton *)[_viewTool viewWithTag:2];
    btn.selected = NO;
    btn = (UIButton *)[_viewTool viewWithTag:3];
    btn.selected = NO;
    btn = (UIButton *)[_viewTool viewWithTag:4];
    btn.selected = NO;
    
    btn = (UIButton *)[_viewTool viewWithTag:tag];
    btn.selected = status;
    
}

- (void)loadPeople:(NSInteger)type
{
    if (_nav) {
        _nav = nil;
        _homeCtrl = nil;
    }
    _homeCtrl = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    _homeCtrl.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - ToolBarHeight);
    _nav = [[UINavigationController alloc] initWithRootViewController:_homeCtrl];
    _nav.navigationBarHidden = YES;
    [self.view insertSubview:_nav.view atIndex:0];
    _nav.view.height = ScreenHeight - ToolBarHeight;
    
    
    [self btnWithTag:1 select:YES];
}

- (void)getData
{
    if (_typeDo == 0) {//待办
        _currentPage = kStartPage;
        [self.theRequest netRequestNeedDealListStar:_currentPage dotype:_typeDo size:PageSize];

    } else {//待阅
        _currentPageDo = kStartPage;
        [self.theRequest netRequestNeedDealListStar:_currentPageDo dotype:_typeDo size:PageSize];
    }
}

- (void)nextPage
{
    if (_typeDo == 0) {//待办
        _currentPage++;
        [self.theRequest netRequestNeedDealListStar:_currentPage dotype:_typeDo size:PageSize];
        
    } else {//待阅
        _currentPageDo++;
        [self.theRequest netRequestNeedDealListStar:_currentPageDo dotype:_typeDo size:PageSize];
    }
}

#pragma mark 是否自动登录
- (void)loadLogin:(BOOL)states
{
    [_nav popToRootViewControllerAnimated:NO];

    NSString *strCtrlName = [AppDelegate strCtrlName:@"LoginViewController"];
    LoginViewController *loginCtrl = [[LoginViewController alloc] initWithNibName:strCtrlName bundle:nil];
    [AppDelegate getAppDelegate].loginCtrlShare = loginCtrl;
    loginCtrl.isAuto = states;
    [loginCtrl setLoginSuccess:^(LoginViewController *login){
        //登录成功走的block
        [AppDelegate getAppDelegate].loginCtrlShare = nil;
		//登录成功的回调函数
        [self loadLoginSuccessData];
    }];
    __block NetRequest *netRequest = self.theRequest;
    [loginCtrl setUpdateSuccess:^{//更新地址
        [netRequest netRequestVersion];
    }];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    nav.navigationBarHidden = YES;
    [self presentViewController:nav animated:NO completion:^{}];

}

- (void)loadLoginSuccessData
{
    [self loadPeople:0];
    [self.theRequest netRequestgetSubMenuListMenuid:@""];
}

#pragma mark NetRequestDelegate
- (void)netRequest:(int)tag Finished:(NSDictionary *)model 
{
    if (tag == NotifyMsgList) {
        _totalPage = [model[@"tcount"] integerValue];
        //    if (_totalPage == 0) {
        //        return;
        //    }
        if (_currentPage == kStartPage) {//是第一页
            [_muArrCtrl removeAllObjects];
        }
        NSArray *arr = model[@"list"];
        [_muArrCtrl addObjectsFromArray:arr];
        [_pullTableView reloadData];
    } else if (tag == SubMenuList) {
        
        NSArray *arr = model[@"list"];
        
        [AppDelegate getAppDelegate].arrModule = arr;
        
        [_muArrMenu[1] addObjectsFromArray:arr];
        
        NSInteger num = [arr count];
        CGFloat height = num * _heightMenuCell;
        _tableViewSmallTwo.height = height;
        _tableViewSmallTwo.top = ScreenHeight;
        
    } else if (tag == NeedDealList) {//待办
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
    } else if (tag == NeedDealListOne) {//待阅
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
    } else if (tag == Version) {//检测更新
        NSString *version = model[@"iosver"];
        NSString *locationVersion = [SBAppMessage appVersion];
        if ([version compare:locationVersion options:NSNumericSearch] == NSOrderedDescending) {//大于
            //需要更新
            self.strUpdateUrl = model[@"iosurl"];
            
            NSString *strMessage = [NSString stringWithFormat:@"是否更新版本 %@",version];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新版本" message:strMessage delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
            [alertView show];
        }
    }
}

 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.strUpdateUrl]];
    }
}

- (void)pageMinusOne
{
    (_typeDo == 0) ? (_currentPage--):(_currentPageDo--);
    if (_currentPage <= kStartPage) {
        _currentPage = kStartPage;
    }
    if (_currentPageDo <= kStartPage) {
        _currentPageDo = kStartPage;
    }
}

#pragma mark 加载控制器
- (void)loadCtrl
{

}

- (void)showTableView:(UITableView *)tableV
{
    tableV.hidden = NO;

    [UIView animateWithDuration:0.3 animations:^{
        tableV.top = _viewTool.top - tableV.height;
    }];
//    UIButton *btn = (UIButton *)[_viewTool viewWithTag:_currentTag];
//    btn.selected = YES;
}

- (void)hiddenTableView:(UITableView *)tableV
{
    [UIView animateWithDuration:0.3 animations:^{
        tableV.top = ScreenHeight;
    } completion:^(BOOL finsh) {
        tableV.hidden = YES;
    }];
//    UIButton *btn = (UIButton *)[_viewTool viewWithTag:_currentTag];
//    btn.selected = NO;
}

#pragma mark 控制器之间切换按钮事件
- (IBAction)btnSelectCtrlClicked:(UIButton *)sender
{
    UITableView *tableV = (UITableView *)[self.view viewWithTag:(10+_currentTag)];

    if (_currentTag == sender.tag) {//相等时
        if (tableV.hidden) {
            [self showTableView:tableV];

        } else {
            [self hiddenTableView:tableV];
        }
        return;
    } else {
    }
    
    if (!tableV.hidden) {
        [self hiddenTableView:tableV];
    }
    _currentTag = sender.tag;
  
    tableV = (UITableView *)[self.view viewWithTag:(10+_currentTag)];
    [self showTableView:tableV];
    [tableV reloadData];
}

#pragma mark UIButton按钮事件
- (IBAction)btnGongwenClicked:(UIButton *)sender
{
    UITableView *tableV = (UITableView *)[self.view viewWithTag:(10+_currentTag)];
    if (tableV.hidden) {
    } else {
        [self hiddenTableView:tableV];
    }

    SendReceiveViewController *ctrl = [[SendReceiveViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendReceiveViewController"] bundle:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
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
    if (tableView == _pullTableView) {//首页列表
        NSArray *arr = _muArrCtrl[_typeDo];
        if (arr.count == 0) {
            return 0;
        }
        return arr.count;
    } else {//栏目
        
    }
    return [_muArrMenu[_currentTag - 1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _pullTableView) {//首页列表
        NSArray *arr = _muArrCtrl[_typeDo];
        if (arr.count == 0) {
            return 0;
        }
        return [MattersCell cellHeight:arr[indexPath.row]];
    }
    return _heightMenuCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _pullTableView) {//首页列表
        static NSString *identifier = @"MattersCell";
        MattersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [MattersCell loadFromXibWithOwner:self];
        }
        NSArray *arr = _muArrCtrl[_typeDo];
        if (arr.count > 0) {
            [cell loadData:arr[indexPath.row]];
        }
        
        return cell;
    }
    //栏目
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,_widthMenuCell, _heightMenuCell)];
        labelTitle.tag = 1002;
        labelTitle.font = SystemFontOfSize(_fontSize);
        labelTitle.textAlignment = NSTextAlignmentCenter;
        labelTitle.textColor = WhiteColor;//RGBFromColor(0x767676);
        labelTitle.backgroundColor = ClearColor;
        cell.contentView.backgroundColor = ClearColor;//RGBFromColor(0xF2F2F2);
        [cell addSubview:labelTitle];
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:ImageWithImgName(@"menuBg")];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *label = (UILabel *)[cell viewWithTag:1002];
    
    NSArray *arr = _muArrMenu[tableView.tag - 10 - 1];
    if (arr.count == 0) {
        return cell;
    }
    NSString *title = arr[indexPath.row];
    if (tableView == _tableViewSmallTwo) {
        NSDictionary *dic = arr[indexPath.row];
        title = dic[@"title"];
    }
    
    if ([AppDelegate isPop3]) {
        if (indexPath.row == 0 && [title isEqualToString:@"绑定邮箱"]) {
            MailMessage *message = [MailMessage sharedInstance];
            BOOL isEmailLogin = message.isMailLogin;
            if (isEmailLogin) {//已绑定邮箱
                title = @"注销邮箱";
            }
        }
    }

    
    label.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    
    BOOL isPop3 = [AppDelegate isPop3];

     if (tableView == _pullTableView) {//首页列表
         ShowWebViewController *ctrl = [[ShowWebViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ShowWebViewController"] bundle:nil];
         NSArray *arr = _muArrCtrl[_typeDo];
         NSDictionary *dic = arr[indexPath.row];
         NSString *url = dic[@"url"];
         ctrl.strUrl = url;
         ctrl.strTopTitle = self.strTitle;
//         ctrl.isDownFileUrl = YES;
         [self.navigationController pushViewController:ctrl animated:YES];
     } else {//栏目
         [self hiddenTableView:tableView];
         switch (_currentTag) {
             case 1:{//个人事务
                 [self btnWithTag:1 select:YES];
                 NSInteger type = 0;
                 if (index == 0) {//待阅事宜
                     type = 1;
                 } else {//待办事宜
                 }
                 _homeCtrl.type = type;
                 [_nav popToRootViewControllerAnimated:NO];
             }break;
             case 2:{//公文
                 [self btnWithTag:2 select:YES];
                 [_nav popToRootViewControllerAnimated:NO];

                 NSArray *arr = _muArrMenu[tableView.tag - 10 - 1];
                 NSDictionary *dic = arr[indexPath.row];
                 SendReceiveViewController *ctrl = [[SendReceiveViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendReceiveViewController"] bundle:nil];
                 ctrl.dicData = dic;
                 [_nav pushViewController:ctrl animated:YES];
             }break;
             case 3:{//邮件
                 [self btnWithTag:3 select:YES];

                 [_nav popToRootViewControllerAnimated:NO];
                 
                 if (isPop3) {
                     BOOL isEmailLogin = [MailMessage sharedInstance].isMailLogin;
                     if (!isEmailLogin) {
                         BindingEmailViewController *ctrl = [[BindingEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"BindingEmailViewController"] bundle:nil];
                         [[AppDelegate getNav] pushViewController:ctrl animated:YES];
                         return;
                     }
                     
                     if (index == 0) {
                         SendEmailPOPViewController *ctrl = [[SendEmailPOPViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailPOPViewController"] bundle:nil];
                         [self.navigationController pushViewController:ctrl animated:YES];
                     } else if (index == 3) {//草稿
                         EmailDraftListViewController *ctrl = [[EmailDraftListViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailDraftListViewController"] bundle:nil];
                         [_nav pushViewController:ctrl animated:YES];
                     } else {
                         EmailPopListViewController *ctrl = [[EmailPopListViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailPopListViewController"] bundle:nil];
                         ctrl.type = index-1;
                         [_nav pushViewController:ctrl animated:YES];
                     }
                     return;
                 }
                 
                 if (index == 0) {
                     SendEmailViewController *ctrl = [[SendEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"SendEmailViewController"] bundle:nil];
                     ctrl.delegate = self;
                     [self.navigationController pushViewController:ctrl animated:YES];
                 } else {
                     EmailListViewController *ctrl = [[EmailListViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailListViewController"] bundle:nil];
                     ctrl.type = index-1;
                     [_nav pushViewController:ctrl animated:YES];
                 }
             }break;
             case 4:{//更多
                 [self btnWithTag:4 select:YES];
                 [_nav popToRootViewControllerAnimated:NO];

                 if (isPop3) {
                     if (index == 0) {//绑定邮箱
                         BindingEmailViewController *ctrl = [[BindingEmailViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"BindingEmailViewController"] bundle:nil];
                         [[AppDelegate getNav] pushViewController:ctrl animated:YES];
                         return;
                     } else {
                         --index;
                     }
                 }
                 
                 if (index == 0) {//已阅事宜
                        ToReadViewController *ctrl = [[ToReadViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ToReadViewController"] bundle:nil];
                     ctrl.type = 3;
                     [_nav pushViewController:ctrl animated:YES];
                 } else if (index == 1) {//已办事宜
                     ToReadViewController *ctrl = [[ToReadViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ToReadViewController"] bundle:nil];
                     ctrl.type = 2;
                     [_nav pushViewController:ctrl animated:YES];
                 } else if (index == 2) {//综合查询
                     IntegratedQueryViewController *ctrl = [[IntegratedQueryViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"IntegratedQueryViewController"] bundle:nil];
                     [_nav pushViewController:ctrl animated:YES];
                 } else if (index == 3) {//通讯录
                     if (isPop3) {
                            EmailContactsViewController *ctrl = [[EmailContactsViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailContactsViewController"] bundle:nil];
                         [_nav pushViewController:ctrl animated:YES];
                         return;
                     }
                     ContactsViewController *ctrl = [[ContactsViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ContactsViewController"] bundle:nil];;
                     [_nav pushViewController:ctrl animated:YES];
                 } else if (index == 4) {//注销
                     [[AppDelegate getAppDelegate] logout];
                 }
             }break;
             default:
                 break;
         }
     }
    
}

- (void)sendEmailSuccess
{
    EmailListViewController *ctrl = [[EmailListViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"EmailListViewController"] bundle:nil];
    ctrl.type = 0;
    [_nav pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
