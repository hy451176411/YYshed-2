//
//  EmailContactsViewController.m
//  Itserv_oa
//
//  Created by admin on 15/3/12.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import "EmailContactsViewController.h"
#import "PeopleTableViewCell.h"
#import "DirBtnView.h"
#import "RADataObject.h"
#import "PeopleMessageView.h"
@interface EmailContactsViewController ()
{
    IBOutlet UIView *_viewSearch;//搜索视图
    IBOutlet UITextField *_fieldSearch;//搜索
    
    IBOutlet UITableView *_tableViewContacts;//通讯录列表
    
    IBOutlet UITableView *_tableViewSearch;//搜索列表
    
    NSMutableArray *_muArrPeople;//所有联系人不分组
    
    NSMutableArray *_muArrSelectPeople;//选择的人
    
    NSMutableArray *_muArrDir;
    NSMutableArray *_muArrDirTitle;
    
    NSMutableArray *_muArrReulst;
    NSInteger _currentPage;
    NSInteger _totalPage;
    
    NSMutableArray *_muArrSearch;
    
    int num;

    __weak IBOutlet UIScrollView *_scrollViewBtnContent;
    __weak IBOutlet UIButton *_btnRoot;
    
}
@property (strong, nonatomic) NSString *dept;

@end

@implementation EmailContactsViewController

- (void)viewDidLoad {
    _isRightBtn = YES;

    [super viewDidLoad];
    
    self.strTitle = @"通讯录";
    
    self.dept = @"广东检验检疫局";
    
    _viewSearch.top = _heightTop;
    
    CGFloat originY = _heightTop + _viewSearch.height;
    
    if (_type >= 1) {//选择联系人
        _btnRight.hidden = NO;
        [self btnReplaceRightWithImgNameArr:nil title:@"完成"];
    } else {
        _btnRight.hidden = YES;
    }

    CGFloat height = ScreenHeight - originY - ToolBarHeight;
    
    if (_type >= 1) {
        height = ScreenHeight - _heightTop - _viewSearch.height;
    }
    
    _tableViewSearch.frame = CGRectMake(0, originY, ScreenWidth, height);
    _tableViewSearch.hidden = YES;
    
    _tableViewContacts.frame = CGRectMake(0, originY, ScreenWidth, height);
    
    _muArrReulst = [[NSMutableArray alloc] init];
    _muArrDir = [[NSMutableArray alloc] init];
    _muArrDirTitle = [[NSMutableArray alloc] init];
    
    _muArrSelectPeople = [[NSMutableArray alloc] init];
    
    [self netRequestDept:@[]];
    
//    NSArray *arrTitle = [[AppDelegate getAppDelegate].strTitleApp componentsSeparatedByString:@"局"];
    
//    NSString *title = [NSString stringWithFormat:@"%@局",arrTitle[0]];
    [self updateDirBtn:_btnRoot title:self.dept];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 选择联系人后完成按钮
- (void)btnRightClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(contactsWithPeople:withType:)]) {
        [_delegate contactsWithPeople:_muArrSelectPeople withType:_type];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)netRequestDept:(NSArray *)arrDept
{
    NSString *strDept = [arrDept componentsJoinedByString:@"\\"];
    if (arrDept.count != 0) {
        strDept = [NSString stringWithFormat:@"%@\\%@",self.dept,strDept];
    } else {
        strDept = self.dept;
    }
    [self.theRequest netRequestEmailContactListDept:strDept];
    [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];
}

- (void)updateDirBtn:(UIButton *)btn title:(NSString *)title
{
    btn.titleLabel.font = SystemFontOfSize(14);
    
    NSString *strImgName = @"";
    if (btn == _btnRoot) {
        strImgName = @")";
    } else {
        strImgName = @"))";
    }
    UIImage *img = [UIImage imageNamed:strImgName];
    img = [img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.height = 35;
    
    CGFloat width = btn.width;
    if (width > img.size.width) {
        
        if (btn == _btnRoot) {
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            width = btn.width + 10;
        } else {
            width = btn.width + 25;
        }
    } else {
        
        if (btn == _btnRoot) {
            width = img.size.width + 10;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        } else {
            width = img.size.width + 25;
        }
    }
    btn.width = width;
}

#pragma mark 请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
    [SBPublicAlert hideMBprogressHUD:self.view];
    [_tableViewContacts setContentOffset:CGPointMake(0, 0)];
    
    [_muArrReulst removeAllObjects];
    NSArray *arr = model[@"list"];
    NSMutableArray *muArr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        RADataObject *dataObj = [[RADataObject alloc] init];
        NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:arr[i]];
        NSString *personid = muDic[@"itemname"];
        NSString *personMail = muDic[@"mail"];
        [muDic setObject:personid forKey:@"personname"];
        [muDic setObject:personMail forKey:@"personid"];
        dataObj.dicOrgparent = muDic;
        [muArr addObject:dataObj];
    }
    
    [_muArrReulst addObjectsFromArray:muArr];
    
    [_tableViewContacts reloadData];
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
    [super netRequest:tag Failed:model];
    if (tag == ContactSearch) {
        return;
    }
    [self moveLast];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
    [super netRequest:tag requestFailed:message];
    if (tag == ContactSearch) {
        return;
    }
    [self moveLast];
}

- (void)moveLast
{
    if (_muArrDir.count > 0) {
        DirBtnView *dir = [_muArrDir lastObject];
        
        [_scrollViewBtnContent setContentSize:CGSizeMake(_scrollViewBtnContent.size.width - dir.width - 10, 0)];
        
        [dir removeFromSuperview];
        
        [_muArrDir removeLastObject];
        
        [_muArrDirTitle removeLastObject];
    }
}

#pragma mark 根目录按钮
- (IBAction)btnRootClicked:(UIButton *)sender {
    [_muArrSelectPeople removeAllObjects];

    [self.view endEditing:YES];
    [self netRequestDept:@[]];
    
    for (DirBtnView *dir in _muArrDir) {
        [dir removeFromSuperview];
    }
    
    [_muArrDir removeAllObjects];
    [_muArrDirTitle removeAllObjects];
}

#pragma mark 搜索按钮事件
- (IBAction)btnSearchClicked:(UIButton *)sender
{
    [_muArrSelectPeople removeAllObjects];
    
    NSString *strSearch = _fieldSearch.text;
    if (strSearch.length > 0) {
        [self.view endEditing:YES];
        [self.theRequest netRequestPeopleSearch:strSearch];
        [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];
    } else {
        [self netRequestDept:@[]];
    }
}

#pragma mark UITableViewDetegate  arc
//有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每个section中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _muArrReulst.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIButton *btnAdd = nil;
    
    static NSString *identifier = @"PeopleTableViewCell";
    PeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [PeopleTableViewCell loadFromXibWithOwner:self];
        
        if (_type > 0) {
            //是否添加到数组
             btnAdd = (UIButton *)[cell viewWithTag:222];
            if (!btnAdd) {
                btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
                btnAdd.frame = CGRectMake(ScreenWidth - 40, 5, 30, 30);
                btnAdd.tag = 222;
                [cell addSubview:btnAdd];
                [btnAdd setImage:[UIImage imageNamed:@"checkbox_disabled"] forState:UIControlStateNormal];
                [btnAdd setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
                btnAdd.userInteractionEnabled = NO;
            }
        }
    }
    
    btnAdd.hidden = NO;
    RADataObject *dataObj = _muArrReulst[indexPath.row];
    NSDictionary *dic = dataObj.dicOrgparent;
    
    NSInteger type = [dic[@"itemtype"] integerValue];
    if (type == 1) {//1 人
        cell.imageView.image = ImageWithImgName(@"peopleIcon");
        cell.imageView.height = 23;
        cell.imageView.width = 30;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {// 2  部门
        btnAdd.hidden = YES;
        cell.imageView.image = ImageWithImgName(@"orgImgIcon");
        cell.imageView.height = 18;
        cell.imageView.width = 31;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = dic[@"itemname"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    RADataObject *dataObj = _muArrReulst[indexPath.row];
    NSDictionary *dic = dataObj.dicOrgparent;
    
    NSInteger type = [dic[@"itemtype"] integerValue];
    if (type == 2) {//部门  有下一级
        
        NSString *itemname = dic[@"itemname"];
        DirBtnView *btnView = [DirBtnView buttonWithType:UIButtonTypeCustom];
        btnView.top = 3;
        btnView.height = 35;
        CGFloat leftX = _btnRoot.right;
        if (_muArrDir.count != 0) {
            DirBtnView *lastBtn = [_muArrDir lastObject];
            leftX = lastBtn.right;
        }
        btnView.tag = _muArrDir.count + 1;
        btnView.left = leftX - 10;
        
        [self updateDirBtn:btnView title:itemname];
        
        btnView.dicData = dic;
        
        [btnView addTarget:self action:@selector(btnDirClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollViewBtnContent addSubview:btnView];
        [_scrollViewBtnContent setContentSize:CGSizeMake(btnView.right + 5, 0)];
        
        [_muArrDir addObject:btnView];
        
        [_muArrDirTitle addObject:dic[@"itemname"]];
        
        [self netRequestDept:_muArrDirTitle];
    } else if (type == 1 && _type > 0) {//人
        RADataObject *data = _muArrReulst[indexPath.row];
        data.isAdd = !data.isAdd;
        PeopleTableViewCell *cell = (PeopleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        UIButton *btnAdd = (UIButton *)[cell viewWithTag:222];
        btnAdd.selected = data.isAdd;
        
        if ([_muArrSelectPeople containsObject:data]) {//已保存到数组，将数组移除
            [_muArrSelectPeople removeObject:data];
        } else {//将数据添加到数组
            [_muArrSelectPeople addObject:data];
        }
        NSLog(@"select:%@",_muArrSelectPeople);
    } else {//显示人信息
        NSLog(@"查看信息");
        PeopleMessageView *messageView = [PeopleMessageView loadFromXibWithOwner:self];
        [messageView loadDataRADataObject:dataObj];
        [[AppDelegate getNav].view addSubview:messageView];
    }
}

#pragma mark UIButton按钮事件
- (void)btnDirClicked:(DirBtnView *)sender
{
    [_muArrSelectPeople removeAllObjects];
    [self.view endEditing:YES];
    NSInteger index = sender.tag - 1;
    
    DirBtnView *lastDir = [_muArrDir lastObject];
    if (sender.tag == lastDir.tag) {
        return;
    } else {
        for (int i = _muArrDir.count - 1; i > index ; i--) {
            DirBtnView *dir = _muArrDir[i];
            
            [_muArrDir removeObjectAtIndex:i];
            [dir removeFromSuperview];
            [_muArrDirTitle removeObjectAtIndex:i];
        }
    }
    
    [self netRequestDept:_muArrDirTitle];
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
