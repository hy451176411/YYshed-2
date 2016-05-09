//
//  ContactsViewController.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsCell.h"
#import "RADataObject.h"
#import "RATreeView.h"
#import "OrgCell.h"
#import "EGORefreshTableHeaderView.h"
#import "RATreeView+Private.h"
#import "PeopleMessageView.h"

@interface ContactsViewController ()<RATreeViewDelegate, RATreeViewDataSource,EGORefreshTableHeaderDelegate>
{
    IBOutlet UIView *_viewSearch;//搜索视图
    IBOutlet UITextField *_fieldSearch;//搜索
    
    IBOutlet UITableView *_tableViewContacts;//通讯录列表
    
    IBOutlet UITableView *_tableViewSearch;//搜索列表
    
    NSMutableArray *_muArrPeople;//所有联系人不分组
    
    NSMutableArray *_muArrSelectPeople;//选择的人
    
    NSMutableArray *_muArrReulst;
    NSInteger _currentPage;
    NSInteger _totalPage;

    NSMutableArray *_muArrSearch;
    
    int num;
}
@property (weak, nonatomic) RATreeView *treeView;


@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isRightBtn = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.strTitle = @"通讯录";
    
    _viewSearch.top = _heightTop;
    
    CGFloat originY = _heightTop + _viewSearch.height;
    
    if (_type >= 1) {//选择联系人
        _btnRight.hidden = NO;
        [self btnReplaceRightWithImgNameArr:nil title:@"完成"];
    } else {
        _btnRight.hidden = YES;
    }
    
    _tableViewSearch.frame = CGRectMake(0, originY, ScreenWidth, ScreenHeight - originY - ToolBarHeight);
    _tableViewSearch.hidden = YES;
    
    _muArrReulst = [[NSMutableArray alloc] init];
    _muArrPeople = [[NSMutableArray alloc] init];
    _muArrSearch = [[NSMutableArray alloc] init];
    
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"muArrPeople"];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"muArrReulst"];
    NSArray *arrReulst = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];

    //选择的联系人
    _muArrSelectPeople = [[NSMutableArray alloc] init];
    
    _currentPage = kStartPage;
    _totalPage = 0;
    
    CGFloat height = ScreenHeight - _heightTop - _viewSearch.height - ToolBarHeight;
    
    if (_type >= 1) {
        height = ScreenHeight - _heightTop - _viewSearch.height;
    }
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, _heightTop+ _viewSearch.height, ScreenWidth, height)];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    treeView.backgroundColor = ClearColor;
    
    self.treeView = treeView;
    [self.view addSubview:treeView];

    _pullTableView = self.treeView.tableView;

    if (arr.count > 0) {//有数据，直接显示
        [_muArrReulst addObjectsFromArray:arrReulst];
        [_muArrPeople addObjectsFromArray:arr];
    } else {//没数据发送请求
//        [self loadArr:@[]];
        [self treeViewRefreshView:self.treeView];
        [SBPublicAlert showMBProgressHUD:@"加载中" andWhereView:self.view states:NO];
    }
    
    // Do any additional setup after loading the view from its nib.
}


- (NSArray *)arrayWithChildrenArr:(NSArray *)childrenArr arrAllOrg:(NSArray *)arrAllOrg
{
    __autoreleasing NSMutableArray *muArrChildren = [[NSMutableArray alloc] init];
    for (int j = 0; j < childrenArr.count; j++) {
        RADataObject *dataChildrenOrg = childrenArr[j];
        NSString *strOrgId = dataChildrenOrg.strOrgId;
        NSString *strPredicate = [NSString stringWithFormat:@"strOrgparentid = '%@'",strOrgId];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:strPredicate];
        //找到的子部门
        NSArray *arrOrgChildren = [arrAllOrg filteredArrayUsingPredicate:predicate];
        if (arrOrgChildren.count > 0) {
            [self arrayWithChildrenArr:arrOrgChildren arrAllOrg:arrAllOrg];
        }
        num += arrOrgChildren.count;
        [dataChildrenOrg.children addObjectsFromArray:arrOrgChildren];
    }
    [muArrChildren addObjectsFromArray:childrenArr];
    return muArrChildren;
}

- (void)treeViewRefreshView:(RATreeView *)treeView {
    _currentPage = kStartPage;
    [self.theRequest netRequestContactListStart:_currentPage];
//    NSDictionary *model = [strJson JSONValue];
//    model = model[@"funcdata"];
//    NSLog(@"modelmodelmodel11:%@",model);
//    _totalPage = [model[@"tcount"] integerValue];
//    if (_totalPage == 0) {
//        [SBPublicAlert showMBProgressHUD:@"没有联系人" andWhereView:self.view hiddenTime:kHiddenAlertTime];
//        return;
//    }
//    NSArray *arr = model[@"list"];
//    [_muArrPeople removeAllObjects];
//    [_muArrPeople addObjectsFromArray:arr];
//    
//    [_muArrSelectPeople removeAllObjects];
//    [_muArrReulst removeAllObjects];
//    
//    //获取数据,获得一组后,刷新UI.
//    [self loadArr:arr];

}

- (void)viewWillAppear:(BOOL)animated
{
//    _treeView.hidden = NO;
//    _tableViewSearch.hidden = YES;
//    _fieldSearch.text = @"";
//    [_treeView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.treeView.tableView tableViewDidDragging];
}


#pragma mark 选择联系人后完成按钮
- (void)btnRightClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(contactsWithPeople:withType:)]) {
        [_delegate contactsWithPeople:_muArrSelectPeople withType:_type];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RADataObject *data = (RADataObject *)item;
    if (!data.isOrgparentid && !data.isPeople) {//一级菜单
    } else if (data.isOrgparentid && !data.isPeople) {//二级部门
    } else {//联系人
        return 40;
    }
    return 50;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    //  if ([item isEqual:self.expanded]) {
    //    return YES;
    //  }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
//    if (treeNodeInfo.treeDepthLevel == 0) {
//        cell.backgroundColor = RGBFromColor(0xF7F7F7);
//    } else if (treeNodeInfo.treeDepthLevel == 1) {
//        cell.backgroundColor = RGBFromColor(0xD1EEFC);
//    } else if (treeNodeInfo.treeDepthLevel == 2) {
//        cell.backgroundColor = RGBFromColor(0xE0F8D8);
//    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    
    RADataObject *data = (RADataObject *)item;
    NSDictionary *dic = data.dicOrgparent;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.backgroundColor = ClearColor;
    cell.contentView.backgroundColor = ClearColor;
    
    UIImageView *imgViewIcon = (UIImageView *)[cell viewWithTag:133];
    if (!imgViewIcon) {
        imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 44, 44)];
        imgViewIcon.tag = 133;
        [cell addSubview:imgViewIcon];
        imgViewIcon.image = [UIImage imageNamed:@"back"];
    }
    
    UIImageView *imgViewLine = (UIImageView *)[cell viewWithTag:122];
    if (!imgViewLine) {
        imgViewLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, ScreenWidth, 1)];
        imgViewLine.tag = 122;
        imgViewLine.backgroundColor = [UIColor colorWithRed:231 green:231 blue:231 alpha:1];
        [cell addSubview:imgViewLine];
    }
    
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:111];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 20, 20, 9, 13)];
        imgView.tag = 111;
        [cell addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"jiantou.png"];
    }
    
    //是否添加到数组
    UIButton *btnAdd = (UIButton *)[cell viewWithTag:222];
    if (!btnAdd) {
        btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake(ScreenWidth - 40, 5, 30, 30);
        btnAdd.tag = 222;
        [cell addSubview:btnAdd];
        [btnAdd setImage:[UIImage imageNamed:@"checkbox_disabled"] forState:UIControlStateNormal];
        [btnAdd setImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
        btnAdd.userInteractionEnabled = NO;
    }
    
    
    if (data.isOpen) {
        imgView.transform = CGAffineTransformMakeRotation(M_PI/2);
    } else {
        imgView.transform = CGAffineTransformMakeRotation(0);
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.backgroundColor = ClearColor;
    
    CGPoint point = imgViewIcon.center;
    NSInteger num = treeNodeInfo.treeDepthLevel;

    if (data.isPeople) {//是联系人
        
        if (_type >= 1) {
            btnAdd.selected = data.isAdd;
            btnAdd.hidden = NO;
        } else {
            btnAdd.hidden = YES;
        }

        
        imgViewLine.top = 38;
        cell.textLabel.text = [NSString stringWithFormat:@"       %@",dic[@"personname"]];
        
        NSString *strPhone = dic[@"phoneno"];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"          %@",strPhone];
        cell.detailTextLabel.textColor = GrayColor;
        imgView.hidden = YES;
        
        
        imgViewIcon.image = ImageWithImgName(@"peopleIcon");
        imgViewIcon.height = 23;
        imgViewIcon.width = 30;

        point.y = 40/2;
//        if (num > 1) {
            point.x = (25)+ (num * 30);
//        }

    } else {
        btnAdd.hidden = YES;
        
        imgViewLine.top = 48;
        imgView.hidden = NO;
        cell.textLabel.text = dic[@"orgname"];
        cell.detailTextLabel.text = @"";
//        if (treeNodeInfo.treeDepthLevel == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"       %@",dic[@"orgname"]];
//        }
        imgViewIcon.image = ImageWithImgName(@"orgImgIcon");
        imgViewIcon.height = 18;
        imgViewIcon.width = 31;
        
        point.y = 50/2;
        
        point.x = (25)+ (num * 30);
        
    }
    imgViewIcon.center = point;
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [_muArrReulst count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [_muArrReulst objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}


- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    RADataObject *data = (RADataObject *)item;
    if (!data.isPeople) {
        data.isOpen = !data.isOpen;
        NSArray *arr = data.children;
        for (int i = 0; i < arr.count; i++) {
            RADataObject *childrenData = arr[i];
            childrenData.isOpen = NO;
        }
        UITableViewCell *cell = (UITableViewCell *)[treeView cellForItem:item];
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:111];
       
        if (data.isOpen) {
            imgView.transform = CGAffineTransformMakeRotation(M_PI/2);
        } else {
            imgView.transform = CGAffineTransformMakeRotation(0);
        }

    } else {
        if (_type >= 1) {//需要选择联系人
            RADataObject *data = (RADataObject *)item;
            data.isAdd = !data.isAdd;
            UITableViewCell *cell = (UITableViewCell *)[treeView cellForItem:item];
            UIButton *btn = (UIButton *)[cell viewWithTag:222];
            btn.selected = data.isAdd;

            if ([_muArrSelectPeople containsObject:data]) {//已保存到数组，将数组移除
                [_muArrSelectPeople removeObject:data];
            } else {//将数据添加到数组
                [_muArrSelectPeople addObject:data];
            }
            
//            if (_delegate && [_delegate respondsToSelector:@selector(contactsWithPeople:)]) {
//                [_delegate contactsWithPeople:data];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
        } else {
            PeopleMessageView *messageView = [PeopleMessageView loadFromXibWithOwner:self];
            [messageView loadDataRADataObject:data];
            [[AppDelegate getNav].view addSubview:messageView];
        }
    }

}

#pragma mark
- (void)reloadData
{
    [self.view endEditing:YES];
    [_muArrSelectPeople removeAllObjects];
    [_muArrReulst removeAllObjects];
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"muArrPeople"];

    _fieldSearch.text = @"";
    [self startSearch:0];
    
    _treeView.hidden = NO;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //获取数据,获得一组后,刷新UI.
        [self loadArr:arr];
//        dispatch_async(dispatch_get_main_queue(),^{
            //UI的更新需在主线程中进行
//            [_treeView reloadData];
//        });
//    });
}

#pragma mark 处理数据
- (void)loadArr:(NSArray *)arrPerson
{
//    NSDictionary *dicAa = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"aa" ofType:@"plist"]];
//    arrPerson = dicAa[@"muArrPeople"];
    
//    NSLog(@"%d",(int)arrPerson.count);
    
    NSMutableDictionary *muDicOrg = [NSMutableDictionary dictionary];
    for (int i = 0; i < arrPerson.count; i++) {
        NSDictionary *dicCurrent = arrPerson[i];
        //当前部门的id
        NSString *strOrgId = dicCurrent[@"orgid"];
        if (!muDicOrg[strOrgId]) {
            NSLog(@"没有");
            [muDicOrg setObject:dicCurrent forKey:strOrgId];
        } else {
            //            NSLog(@"有");
        }
    }
    
    NSLog(@"所有部门id:%@",muDicOrg.allKeys);
    
    NSMutableArray *muArrAllOrg = [NSMutableArray array];
    //根部门
    NSMutableArray *muArrAllRootOrg = [NSMutableArray array];
    //所有部门的数组
    NSArray *arrOrg = muDicOrg.allValues;
    //给每个部分分配人员,人员分配完成
    for (int i = 0; i < arrOrg.count; i++) {
        NSDictionary *dicCurrent = arrOrg[i];
        NSString *strOrgId = dicCurrent[@"orgid"];
        NSLog(@"当前部门id:%@,名称:%@",strOrgId,dicCurrent[@"orgname"]);
        NSString *strPredicate = [NSString stringWithFormat:@"orgid = '%@'",strOrgId];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:strPredicate];
        
        NSArray *arrChildren = [arrPerson filteredArrayUsingPredicate:predicate];
        NSMutableArray *muArrChildren = [NSMutableArray array];
        for (int j = 0; j < arrChildren.count; j++) {
            NSDictionary *dicChildren = arrChildren[j];
            RADataObject *dataChildren = [RADataObject dataObjectWithDic:dicChildren children:nil];
            dataChildren.isPeople = YES;
            [muArrChildren addObject:dataChildren];
        }
        RADataObject *dataOrg = [RADataObject dataObjectWithDic:dicCurrent children:muArrChildren];
        dataOrg.strOrgId =  strOrgId;
        dataOrg.strOrgparentid = dicCurrent[@"orgparentid"];
        if ([dataOrg.strOrgparentid isEqualToString:@""]) {
            NSLog(@"为空");
            [muArrAllRootOrg addObject:dataOrg];
        }
        [muArrAllOrg addObject:dataOrg];
    }
    //    NSLog(@"%@----%d",muArrAllOrg,muArrAllOrg.count);
    
    //将部门与部分之间分开
    [muDicOrg removeAllObjects];
    
    NSArray *arrAllOrg = [NSArray arrayWithArray:muArrAllOrg];
    NSLog(@"%d",arrAllOrg.count);
    
    for (int i = 0; i < muArrAllRootOrg.count; i++) {
        RADataObject *dataOrg = muArrAllRootOrg[i];
        //当前部门id
        NSString *strOrgId = dataOrg.strOrgId;
        NSString *strPredicate = [NSString stringWithFormat:@"strOrgparentid = '%@'",strOrgId];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:strPredicate];
        //找到的子部门
        NSArray *arrOrgChildren = [arrAllOrg filteredArrayUsingPredicate:predicate];
        NSArray *arrChildren = [self arrayWithChildrenArr:arrOrgChildren arrAllOrg:arrAllOrg];
        num += arrOrgChildren.count+1;
        [dataOrg.children addObjectsFromArray:arrChildren];
    }
    NSLog(@"%d",num);
    NSLog(@"ffffffff:%@",muArrAllRootOrg);
    
    [_muArrReulst addObjectsFromArray:muArrAllRootOrg];
    [_treeView reloadData];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_muArrReulst];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"muArrReulst"];
    [[NSUserDefaults standardUserDefaults] setObject:arrPerson forKey:@"muArrPeople"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark 请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model {
    [SBPublicAlert hideMBprogressHUD:self.view];
    
    _totalPage = [model[@"tcount"] integerValue];
    if (_totalPage == 0) {
        [SBPublicAlert showMBProgressHUD:@"没有联系人" andWhereView:self.view hiddenTime:kHiddenAlertTime];
        return;
    }
    NSArray *arr = model[@"list"];
    [_muArrPeople removeAllObjects];
    [_muArrPeople addObjectsFromArray:arr];
    
    [_muArrSelectPeople removeAllObjects];
    [_muArrReulst removeAllObjects];
    
    //获取数据,获得一组后,刷新UI.
    [self loadArr:arr];
}

#pragma mark 搜索按钮事件
- (IBAction)btnSearchClicked:(UIButton *)sender
{
    [self startSearch:0];
}

#pragma mark 加载图集
- (void)startSearch:(NSString *)str
{
    if (_fieldSearch.text.length == 0) {//没有搜索关键字
        _tableViewSearch.hidden = YES;
        _treeView.hidden = NO;
        
        for (int i = 0; i < _muArrReulst.count; i++) {
            RADataObject *childrenData = _muArrReulst[i];
            childrenData.isOpen = NO;
        }
        [_treeView reloadData];
        str = @"0";
    } else {
        _tableViewSearch.hidden = NO;
        _treeView.hidden = YES;
        [self searchText];

    }
//    if ([str isEqualToString:@"0"]) {
        [self.view endEditing:YES];
//    }
}

#pragma mark 开始搜索
- (void)searchText
{
    NSString *searchStr = _fieldSearch.text;
    [_muArrSearch removeAllObjects];
    
    NSString *strPredicate = [NSString stringWithFormat:@"personname like '*%@*'",searchStr];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:strPredicate];
    NSArray *arrChildren = [_muArrPeople filteredArrayUsingPredicate:predicate];
    
    for (int i = 0; i < arrChildren.count; i++) {//搜索
        NSDictionary *dicPerson = arrChildren[i];
        RADataObject *dataOrg = [RADataObject dataObjectWithDic:dicPerson children:nil];
        [_muArrSearch addObject:dataOrg];
    }
    [_tableViewSearch reloadData];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self startSearch:0];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    [self performSelector:@selector(startSearch:) withObject:@"1" afterDelay:0.1];
    return YES;
}

#pragma mark UITableViewDetegate
//有多少个section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableViewContacts) {
        return _muArrReulst.count;
    }
    return 1;
}

//每个section中有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _muArrSearch.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ContactsCell";
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [ContactsCell loadFromXibWithOwner:self];
        //是否添加到数组
        UIButton *btnAdd = (UIButton *)[cell viewWithTag:222];
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
    
    UIButton *btnAdd = (UIButton *)[cell viewWithTag:222];
    if (_type >= 1) {
        btnAdd.hidden = NO;
    } else {
        btnAdd.hidden = YES;
    }
    if (tableView == _tableViewSearch) {
        RADataObject *data = _muArrSearch[indexPath.row];

        btnAdd.selected = data.isAdd;
        
        [cell loadDic:data.dicOrgparent];
    } else {
        NSDictionary *dic = _muArrReulst[indexPath.section];
        NSArray *arr = dic[@"keyArr"];
        [cell loadDic:arr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RADataObject *data = _muArrSearch[indexPath.row];
    data.isAdd = !data.isAdd;
    ContactsCell *cell = (ContactsCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIButton *btnAdd = (UIButton *)[cell viewWithTag:222];
    btnAdd.selected = data.isAdd;

    
    if ([_muArrSelectPeople containsObject:data]) {//已保存到数组，将数组移除
        [_muArrSelectPeople removeObject:data];
    } else {//将数据添加到数组
        [_muArrSelectPeople addObject:data];
    }
    
//    RADataObject *data = [RADataObject dataObjectWithDic:dic children:nil];
//    if (_delegate && [_delegate respondsToSelector:@selector(contactsWithPeople:)]) {
//        [_delegate contactsWithPeople:data];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
