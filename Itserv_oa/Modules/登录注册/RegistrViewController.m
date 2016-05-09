//
//  RegistrViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 15/2/4.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import "RegistrViewController.h"

@interface RegistrViewController ()<UITextFieldDelegate,NetRequestDelegate>
{
    
    __weak IBOutlet UILabel *_labelAppTitle;
    __weak IBOutlet UIButton *_btnServer;
    __weak IBOutlet UITextField *_fieldNam;
    __weak IBOutlet UITextField *_fieldPhone;
    __weak IBOutlet UITextField *_fieldOrg;
    __weak IBOutlet UITableView *_tableViewAgency;
    NSMutableArray *_muArrServer;
}
@property (strong, nonatomic) NSDictionary *dicAgency;
@property (nonatomic, retain) NetRequest *theRequest;

@end

@implementation RegistrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBFromColor(0x319FD1);

     _labelAppTitle.textColor = RGBFromColor(0x14729D);
    _labelAppTitle.text = [AppDelegate getAppDelegate].strTitleApp;
    
    
    
    self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
    
    UIImage *imgOrigin = CachedImage(@"SelectType");
    CGSize size = imgOrigin.size;
    UIImage *img = [imgOrigin stretchableImageWithLeftCapWidth:size.width/2 topCapHeight:size.height/2];
    [_btnServer setBackgroundImage:img forState:UIControlStateNormal];
    
    _muArrServer = [[NSMutableArray alloc] init];
    [_muArrServer addObjectsFromArray:self.arrServer];
    
    if (_muArrServer.count == 0) {
        //再次发请求
        [self requestAgency];
    } else {
        [self loadInitData];
    }
    
    _tableViewAgency.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    _tableViewAgency.layer.borderWidth = 1;
    // Do any additional setup after loading the view.
}

- (void)requestAgency
{
    [self.theRequest netRequestAgency];
    [SBPublicAlert showMBProgressHUD:@"加载中..." andWhereView:self.view states:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    if (tag == Server) {//获取机构
        [SBPublicAlert hideMBprogressHUD:self.view];
        NSArray *list = model[@"list"];
        if (list.count > 0) {
            NSDictionary *dic = list[0];
            self.dicAgency = dic;
            NSString *orgname = dic[@"orgname"];
            [_btnServer setTitle:orgname forState:UIControlStateNormal];
        }
        
        [_muArrServer removeAllObjects];
        [_muArrServer addObjectsFromArray:list];
    } else if (tag == Regist) {//注册
        NSString *strMessage = model[@"resultinfo"];
        [SBPublicAlert showMBProgressHUD:strMessage andWhereView:self.view hiddenTime:kHiddenAlertTime];
        [self performSelector:@selector(moveCtrl) withObject:nil afterDelay:kHiddenAlertTime];
    }
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
    [SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
    [SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
}


- (void)moveCtrl
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadInitData
{
    if (_muArrServer.count > 0) {
        NSDictionary *dic = _muArrServer[0];
        self.dicAgency = dic;
        NSString *orgname = dic[@"orgname"];
        [_btnServer setTitle:orgname forState:UIControlStateNormal];
    }
}

#pragma mark UITableViewDetegate  arc
//有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个section中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _muArrServer.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = SystemFontOfSize(15);
    }
    NSDictionary *dic = _muArrServer[indexPath.row];
    cell.textLabel.text = dic[@"orgname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.hidden = YES;
    NSDictionary *dic = _muArrServer[indexPath.row];
    self.dicAgency = dic;
    NSString *orgname = dic[@"orgname"];
    [_btnServer setTitle:orgname forState:UIControlStateNormal];
}

#pragma mark 键盘消失
- (void)keyboardDisappear
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.top = 0;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _tableViewAgency.hidden = YES;
    [self keyboardDisappear];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _tableViewAgency.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.top = -185;
    }];
}

#pragma mark 选择机构
- (IBAction)btnServerClicked:(id)sender {
    
    [self keyboardDisappear];
    _tableViewAgency.hidden = !_tableViewAgency.hidden;

    if (!_tableViewAgency.hidden) {
        _tableViewAgency.left = _btnServer.left;
        _tableViewAgency.width = _btnServer.width;
        
        NSInteger height = _muArrServer.count * 44;
        CGFloat maxHeight = 190;
        if (self.view.height >= 1004) {
            maxHeight = 310;
        }
        
        if (height < maxHeight) {
            _tableViewAgency.height = height;
        } else {
            height = maxHeight;
            _tableViewAgency.height = height;
        }
        
        _tableViewAgency.bottom = _btnServer.top;

        
        [_tableViewAgency reloadData];
    }
}

#pragma mark 确定注册
- (IBAction)btnSureClicked:(id)sender {
    
    [self keyboardDisappear];
    
    NSString *name = [_fieldNam.text stringEncodeWithURLString:_fieldNam.text];
    NSString *bureau = self.dicAgency[@"orgid"];
    NSString *dept = [_fieldOrg.text stringEncodeWithURLString:_fieldOrg.text];
    [self.theRequest netRequestRegistUsername:name phone:_fieldPhone.text bureau:bureau dept:dept];
    [SBPublicAlert showMBProgressHUD:@"注册中..." andWhereView:self.view states:NO];
}

#pragma mark 取消注册
- (IBAction)btnCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
