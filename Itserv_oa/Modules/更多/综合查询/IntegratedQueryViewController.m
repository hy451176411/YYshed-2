//
//  IntegratedQueryViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "IntegratedQueryViewController.h"
#import "ProcessFileCell.h"
#import "ShowWebViewController.h"


@interface IntegratedQueryViewController ()
{
    IBOutlet UIView *_viewSearch;//搜索视图
    IBOutlet UITextField *_fieldSearch;//搜索
    
    IBOutlet UITableView *_tableViewLike;//综合查询列表
    NSMutableArray *_muArrData;
    IBOutlet UITableView *_tableViewMenu;//模块选择
    
    NSMutableArray *_muArrModule;//模块数据
    IBOutlet UIButton *_btnMenu;//模块按钮
    IBOutlet UIButton *_btnStarTime;//开始时间按钮
    IBOutlet UIButton *_btnEndTime;//结束时间按钮
    
    NSInteger _currentPage;
    NSInteger _total;
    
    IBOutlet UIView *_viewTimeBg;
    IBOutlet UIView *_viewTime;//时间
    IBOutlet UIDatePicker *_datePickerTime;
    
    IBOutlet UILabel *_labelTitleTime;
    NSInteger _type;//1是开始时间  2是结束时间
    
}
@property (nonatomic, retain) NSString *strModuleID;//模块id
@property (nonatomic, retain) NSDate *dateStart;
@property (nonatomic, retain) NSDate *dateEnd;
@property (nonatomic, retain) NSString *strDateStart;
@property (nonatomic, retain) NSString *strDateEnd;

@end

@implementation IntegratedQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadBtnLayer:(UIButton *)btn
{

    [btn setTitleColor:RGBFromColor(0x767676) forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.shadowColor = [UIColor grayColor].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0, 2);
    btn.backgroundColor = WhiteColor;//RGBFromColor(0xF2F2F2);
}

- (void)loadTableViewLayer:(UITableView *)tableV
{
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    tableV.layer.borderWidth = 1;
    tableV.layer.shadowColor = [UIColor grayColor].CGColor;
    tableV.layer.shadowOffset = CGSizeMake(0, 2);
    
    UIButton *btn = _btnMenu;
    [self loadBtnLayer:btn];
    [self loadBtnLayer:_btnStarTime];
    [self loadBtnLayer:_btnEndTime];
    [btn setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    
    NSInteger num = [_muArrModule count];
    CGFloat height = num * 35;
    tableV.height = height;
    tableV.top = _heightTop + btn.top + btn.height - 1;
    
    [self.view bringSubviewToFront:tableV];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strTitle = @"综合查询";
    
    _viewSearch.top = _heightTop;
    
    _tableViewLike.top = _heightTop + _viewSearch.height;
    _tableViewLike.height = ScreenHeight - _heightTop - _viewSearch.height;
    
    _muArrData = [[NSMutableArray alloc] init];
    _muArrModule = [[NSMutableArray alloc] init];
    [_muArrModule addObjectsFromArray:[AppDelegate getAppDelegate].arrModule];
    
    CGFloat originY = _viewSearch.top + _viewSearch.height;
    
    [self loadTableViewWithRect:CGRectMake(0, originY, ScreenWidth, ScreenHeight - originY - ToolBarHeight) style:UITableViewStylePlain];
    
    _tableViewMenu.hidden = YES;
    [self loadTableViewLayer:_tableViewMenu];
    _tableViewMenu.backgroundColor = RGBFromColor(0x43B2E2);
    
    NSDictionary *dic = _muArrModule[0];
    [_btnMenu setTitle:dic[@"title"] forState:UIControlStateNormal];
    self.strModuleID = dic[@"id"];
    
    _currentPage = kStartPage;
    
//    _fieldSearch.text = @"关于";
    
    _viewTime.top = ScreenHeight;
    _viewTimeBg.hidden = YES;
    
    _viewTimeBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _viewTimeBg.top = _heightTop;
    _viewTimeBg.height = ScreenHeight - _heightTop - ToolBarHeight;
    
    [self.view bringSubviewToFront:_viewTimeBg];
    
    _viewSearch.backgroundColor = self.view.backgroundColor;
//    self.view.backgroundColor = WhiteColor;
    // Do any additional setup after loading the view from its nib.
}

- (void)sendRequest
{
    [self.theRequest netRequestNeedDealListStar:_currentPage moduleid:_strModuleID size:PageSize keyword:_fieldSearch.text startTime:self.strDateStart endTime:self.strDateEnd];
}

- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    [SBPublicAlert hideMBprogressHUD:self.view];
    _total = [model[@"tcount"] integerValue];
    
    if (_currentPage == kStartPage) {
        [_muArrData removeAllObjects];
    }

    if (_total == 0) {
         [SBPublicAlert showMBProgressHUD:@"没有数据" andWhereView:self.view hiddenTime:kHiddenAlertTime];
        return;
    }
    NSArray *list = model[@"list"];
    [_muArrData addObjectsFromArray:list];
    
    [self updateTableViewCount:_muArrData.count pageSize:_total];
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

#pragma mark 隐藏键盘
- (void)hiddenKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark 选择时间事件
- (IBAction)pickerSelectTimeChange:(UIDatePicker *)sender
{
}

#pragma mark 取消时间按钮事件
- (IBAction)btnCancelTimeClicked:(UIButton *)sender
{
    [self btnCancelViewClicked:nil];
}

- (NSString *)dateWithLocalTimeZone:(NSDate *)date
{
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSString *loctime = [formatter stringFromDate:date];
    NSArray *arr = [loctime componentsSeparatedByString:@" "];
    NSString *strTime = [NSString stringWithFormat:@"%@",arr[0]];
    return strTime;
}

#pragma mark 确定时间按钮事件
- (IBAction)btnSureTimeClicked:(UIButton *)sender
{
    [self btnCancelViewClicked:nil];
    if (_type == 1) {//开始时间
        self.dateStart = _datePickerTime.date;
        self.strDateStart = [self dateWithLocalTimeZone:self.dateStart];
        [_btnStarTime setTitle:self.strDateStart forState:UIControlStateNormal];
    } else {
        self.dateEnd = _datePickerTime.date;
        self.strDateEnd = [self dateWithLocalTimeZone:self.dateEnd];
        [_btnEndTime setTitle:self.strDateEnd forState:UIControlStateNormal];
    }
}

#pragma mark 取消时间显示按钮事件
- (IBAction)btnCancelViewClicked:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        _viewTime.top = ScreenHeight;
        _viewTimeBg.alpha = 0;
    } completion:^(BOOL finsh){
        _viewTimeBg.hidden = YES;
    }];
}

- (void)showTime
{
    _viewTimeBg.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
//        _viewTime.top = _viewTimeBg.height - _viewTime.height - ToolBarHeight;
        _viewTime.top = _viewTimeBg.height - _viewTime.height;
        _viewTimeBg.alpha = 1;
    } completion:^(BOOL finsh){
    }];

}

#pragma mark 选择模块按钮事件
- (IBAction)btnSelectModuleClicked:(UIButton *)sender
{
    _tableViewMenu.hidden = !_tableViewMenu.hidden;
    [self hiddenKeyboard];
}

#pragma mark 开始时间按钮事件
- (IBAction)btnStarTimeClicked:(UIButton *)sender
{
    [self hiddenMenu];
    [self hiddenKeyboard];
    _type = 1;
    [self showTime];
    
    _labelTitleTime.text = @"开始时间";
}

#pragma mark 结束时间按钮事件
- (IBAction)btnEndTimeClicked:(UIButton *)sender
{
    [self hiddenMenu];
    [self hiddenKeyboard];
    _type = 2;
    [self showTime];
    _labelTitleTime.text = @"结束时间";
}

#pragma mark 搜索按钮事件
- (IBAction)btnSearchClicked:(UIButton *)sender
{
    [self startSearch];
    
}

- (void)hiddenMenu
{
    _tableViewMenu.hidden = YES;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hiddenMenu];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self startSearch];
    return YES;
}

#pragma mark 加载图集
- (void)startSearch
{
    [SBPublicAlert showMBProgressHUD:@"搜索中..." andWhereView:self.view states:NO];
    [self hiddenMenu];
    _currentPage = kStartPage;

    [self sendRequest];
    
    [self.view endEditing:YES];
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
    if (tableView == _tableViewMenu) {
        return _muArrModule.count;
    }
    return _muArrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewMenu) {
        return 35;
    }
    return [ProcessFileCell cellHeight:_muArrData[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableViewMenu) {
        //栏目
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,tableView.width, 35)];
            labelTitle.tag = 1002;
            labelTitle.font = SystemFontOfSize(14);
            labelTitle.textAlignment = NSTextAlignmentCenter;
            labelTitle.textColor = WhiteColor;//RGBFromColor(0x767676);
            cell.contentView.backgroundColor = ClearColor;//RGBFromColor(0xF2F2F2);
            [cell addSubview:labelTitle];
            
//            UIImageView *imgViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35 - 1, cell.width, 1)];
//            
//            imgViewLine.tag = 101;
//            imgViewLine.image = [UIImage imageNamed:@"line"];
//            [cell addSubview:imgViewLine];
            
            UIView *selectView = [[UIView alloc] init];
            selectView.backgroundColor = RGBFromColor(0x2A85AF);
            cell.selectedBackgroundView = selectView;
        }
        cell.backgroundColor = ClearColor;
        UILabel *label = (UILabel *)[cell viewWithTag:1002];
        
        NSDictionary *dic = _muArrModule[indexPath.row];
        label.text = dic[@"title"];
        return cell;
    }
    static NSString *identifier = @"ProcessFileCell";
    ProcessFileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [ProcessFileCell loadFromXibWithOwner:self];
        cell.backgroundColor = ClearColor;
    }
    [cell loadData:_muArrData[indexPath.row]];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableViewMenu) {
        NSDictionary *dic = _muArrModule[indexPath.row];
        [_btnMenu setTitle:dic[@"title"] forState:UIControlStateNormal];
        self.strModuleID = dic[@"id"];
        tableView.hidden = YES;
    } else {
        ShowWebViewController *ctrl = [[ShowWebViewController alloc] initWithNibName:[AppDelegate strCtrlName:@"ShowWebViewController"] bundle:nil];
        NSDictionary *dic = _muArrData[indexPath.row];
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
