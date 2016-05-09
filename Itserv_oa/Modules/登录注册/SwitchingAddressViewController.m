//
//  SwitchingAddressViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-7-22.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "SwitchingAddressViewController.h"

@interface SwitchingAddressViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITextField *_fieldURL;
    __weak IBOutlet UIView *_viewURLBg;
    __weak IBOutlet UITextField *_fieldEmail;
    __weak IBOutlet UIView *_viewEmailBg;
    __weak IBOutlet UITextField *_fieldOAip;
    __weak IBOutlet UIView *_viewOABg;
    
    __weak IBOutlet UIButton *_btnSelectAddress;
    __weak IBOutlet UITableView *_tableViewList;
    NSMutableArray *_muArrList;
    
    NSInteger _selectRow;
}

@end

@implementation SwitchingAddressViewController

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
    self.strTitle = @"切换地址";
    
    _muArrList = [[NSMutableArray alloc] init];
    
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"OA_Address" ofType:@"geojson"];
    NSString *strAddress = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *dic = [strAddress JSONValue];
    [_muArrList addObjectsFromArray:dic[@"addressList"]];
    
    
    dic = [UserDefaults objectForKey:kOAAddressDic];
    if (dic) {
        [_btnSelectAddress setTitle:dic[@"title"] forState:UIControlStateNormal];
    } else {
        [_btnSelectAddress setTitle:@"辽宁 外网 Domino版" forState:UIControlStateNormal];
    }
    _btnSelectAddress.titleLabel.adjustsFontSizeToFitWidth = YES;
    [GlobalData loadViewBorder:_viewOABg];
    [GlobalData loadViewBorder:_viewEmailBg];
    [GlobalData loadViewBorder:_viewURLBg];
    
    [self setSelectTypeIsJave:_isJava];
    
    [self showIp];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"fdsa");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)showIp
{
    _fieldOAip.text = [AppDelegate getAppDelegate].strIp;
    _fieldEmail.text = [AppDelegate getAppDelegate].strMailIP;
    _fieldURL.text = [AppDelegate getAppDelegate].strUrl;
}

#pragma mark 选择版本 1是domino  2是java
- (IBAction)btnSelectTypeClick:(UIButton *)sender
{
    sender.selected = YES;
    if (sender.tag == 1) {
        UIButton *btn = (UIButton *)[_viewContentBg viewWithTag:2];
        btn.selected = NO;
        _isJava = NO;
    } else {
        UIButton *btn = (UIButton *)[_viewContentBg viewWithTag:1];
        btn.selected = NO;
        _isJava = YES;
    }
}

#pragma mark 确认按钮
- (IBAction)btnSureClick:(id)sender
{
    NSString *strOA = [NSString stringWithFormat:@"%@%@",_fieldOAip.text,_fieldURL.text];
    NSString *strEmail = [NSString stringWithFormat:@"%@%@",_fieldEmail.text,_fieldURL.text];;
    
    if ([strOA rangeOfString:@"http://10.44.0.83"].location != NSNotFound) {
        isPop = YES;
    }
    
    [AppDelegate getAppDelegate].strIp = _fieldOAip.text;
    [AppDelegate getAppDelegate].strMailIP = _fieldEmail.text;
    [AppDelegate getAppDelegate].strUrl = _fieldURL.text;
    
    if (strOA.length) {
        [AppDelegate getAppDelegate].strOA = strOA;
    }
    if (strEmail.length) {
        [AppDelegate getAppDelegate].strEmail = strEmail;
    }
    if (strOA.length == 0) {
        return;
    }
    NSString *strIP = _fieldOAip.text;
    if (strIP.length) {
        [AppDelegate getAppDelegate].strIp = strIP;
    }
    
    NSDictionary *dic = _muArrList[_selectRow];

    [UserDefaults setObject:dic forKey:kOAAddressDic];
    [UserDefaults setObject:[NSString stringWithFormat:@"%d",_isJava] forKey:@"isJava"];
//
//    [UserDefaults setObject:_fieldOAip.text forKey:kOAIp];
//    [UserDefaults setObject:_fieldEmail.text forKey:kMailIp];
//    [UserDefaults setObject:_fieldURL.text forKey:kFaceUrl];
    [UserDefaults synchronize];
    
    _updateAddress(dic);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 取消按钮
- (IBAction)btnCancelClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSelectAddressClicked:(UIButton *)sender {
    _tableViewList.hidden = !_tableViewList.hidden;
    
    _tableViewList.left = _btnSelectAddress.left;
    _tableViewList.top = _btnSelectAddress.bottom;
    _tableViewList.width = _btnSelectAddress.width;
    _tableViewList.height = _viewContentBg.height - _tableViewList.top - 10;
}

#pragma mark UITableViewDetegate  arc
//有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个section中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _muArrList.count;
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
        cell.textLabel.font = SystemFontOfSize(13);
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    NSDictionary *dic = _muArrList[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _tableViewList.hidden = YES;
    
    _selectRow = indexPath.row;

    NSDictionary *dic = _muArrList[_selectRow];
    [_btnSelectAddress setTitle:dic[@"title"] forState:UIControlStateNormal];
    
    _fieldOAip.text = dic[@"oa_ip"];
    _fieldEmail.text = dic[@"email_ip"];
    _fieldURL.text = dic[@"urlface"];
    
    BOOL type = [dic[@"type"] boolValue];
    [self setSelectTypeIsJave:type];
}

- (void)setSelectTypeIsJave:(BOOL)isJava
{
    _isJava = isJava;
    NSInteger tag = 1;
    if (_isJava) {
        tag = 2;
    }
    UIButton *btn = (UIButton *)[_viewContentBg viewWithTag:tag];
    [self btnSelectTypeClick:btn];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
