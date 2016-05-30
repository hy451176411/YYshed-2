//
//  ShedHomeViewController.m
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedHomeViewController.h"
#import "Component.h"
#import "FriendGroup.h"
#import "FriendCell.h"
#import "FriendHeader.h"
#import "ShedDetailVC.h"
#import "HomeController.h"
#import "ShedSettingVC.h"




// 遵守FriendHeaderDelegate协议
@interface ShedHomeViewController () <FriendHeaderDelegate,UIWebViewDelegate>

@property(nonatomic, strong) NSArray *friendGroups;
@property (nonatomic, retain) YYNetRequest *theRequest;
@property (nonatomic,strong) AddDevice *addDevice;
@end

@implementation ShedHomeViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"u18.png"]]];
	//添加左边的按钮
	UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
	UIImage *left = [UIImage imageNamed:@"logo.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame =CGRectMake(0, 0, 30, 30);
	img.backgroundColor = [UIColor clearColor];
	item.customView = img ;
	//右边按钮
	UIImage *right = [UIImage imageNamed:@"add.png"];
	
	UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] init];
	UIImageView* rightIV = [[UIImageView alloc] initWithImage:right];
	UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnClick)];
	[rightIV addGestureRecognizer:singleTap];
	rightIV.frame =CGRectMake(0, 0, 25, 25);
	rightIV.backgroundColor = [UIColor clearColor];
	rightItem.customView = rightIV ;
	
	self.navigationItem.leftBarButtonItem =item;
	self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
	self.navigationItem.rightBarButtonItem =rightItem;
	    [self loadTableViewWithRect:CGRectMake(0, 70, ScreenWidth, ScreenHeight  - ToolBarHeight) style:UITableViewStylePlain];
	//初始化中间部分
//	self.tableView.showsVerticalScrollIndicator=NO;
//	self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
//	self.tableView.sectionHeaderHeight = 44;
//	self.tableView.delegate = self;
//	self.tableView.dataSource = self;
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	[_theRequest getUserInfo:session_token user_Agent:@"test"];
}
//iOS不显示状态栏（电池和信号栏）
- (BOOL)prefersStatusBarHidden {
	return NO;
}

/** 加载数据 */
- (NSArray *) friendGroups {
	if (nil == _friendGroups) {
		
		NSMutableArray *mgroupsArray = [NSMutableArray array];
		for (NSDictionary *groupDict in self.groupsArray) {
			FriendGroup *group = [FriendGroup friendGroupWithDictionary:groupDict];
			[mgroupsArray addObject:group];
		}
		self.friendGroups = mgroupsArray;
	}
	
	return _friendGroups;
}

#pragma mark - dataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int nums = self.friendGroups.count;
	return self.friendGroups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	FriendGroup *group = self.friendGroups[section];
	// 先检查模型数据内的伸展标识
	return group.isOpened? group.friends.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	FriendCell *cell = [FriendCell cellWithTableView:_pullTableView];
	FriendGroup *group = self.friendGroups[indexPath.section];
	cell.friendData = group.friends[indexPath.row];
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 192;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 70.0f;
}
/** 自定义每个section的头部 */
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	FriendHeader *header = [FriendHeader friendHeaderWithTableView:_pullTableView];
	// 加载数据
	header.friendGroup = self.friendGroups[section];
	// 设置代理
	header.delegate = self;
	return header;
}

#pragma mark - FriendHeaderDelegate方法
- (void)friendHeaderDidClickedHeader:(FriendHeader *)header {
	if (header.clickView.tag == 100) {
		// 刷新数据
		[_pullTableView reloadData];
	}else{
		ShedDetailVC *control = [[ShedDetailVC alloc] init];
		[self.navigationController pushViewController:control animated:YES];
	}
	
}

- (void) HeaderTitleDidClicked:(FriendGroup *) group{
//	FriendGroup *gg = group;
	HomeShedDetail *control = [[HomeShedDetail alloc] init];
	control.friendGroup = group;
//	UIViewController *controller;
//	controller = [[LineDemoController alloc] init];
	[self.navigationController pushViewController:control animated:YES];
}

-(void)rightBtnClick{
	self.addDevice = [AddDevice loadFromXibWithOwner:self];
	self.addDevice.delegate = self;
	self.addDevice.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
	[self.view addSubview:self.addDevice];
}

-(void)initDataSource:(NSDictionary *)model
{
	NSMutableArray *groups = [NSMutableArray arrayWithCapacity:3];
	NSArray *smartgates = model[@"smartgates"];
	//
	for (int i=0;i<smartgates.count; i++) {
		NSDictionary *smartgate = smartgates[i];
		NSDictionary *smartgateV = smartgate[@"smartgate"];
		NSString *dev_name = smartgateV[@"dev_name"];
		
		NSArray *components = smartgate[@"components"];
		NSString *air_temperature;
		NSString *air_humidity;
		NSString *sn;
		if(components!=nil)
		{
			NSDictionary *component = components[0];
			air_temperature = component[@"air_temperature"];
			if(air_temperature==nil){
				air_temperature= @"0";
			}
			air_humidity = component[@"air_humidity"];
			if(air_humidity==nil){
				air_humidity= @"0";
			}
			sn = smartgateV[@"sn"];
			if(sn==nil){
				sn= @"0";
			}
		}
		
		NSDictionary *dic02=[NSDictionary dictionaryWithObjectsAndKeys:air_temperature,@"air_temperature",air_humidity,@"air_humidity",sn,@"sn", nil];
		NSArray *friends1=[NSArray arrayWithObjects:dic02, nil];
		
		NSDictionary *datas =[NSDictionary dictionaryWithObjectsAndKeys:dev_name,@"name",@"1",@"online",friends1,@"friends", nil];
		[groups addObject:datas];
		
	}
	self.groupsArray = [NSMutableArray arrayWithCapacity:3];
	self.groupsArray = groups;
	if (nil != groups) {
		NSMutableArray *mgroupsArray = [NSMutableArray array];
		int i=0;
		for (NSDictionary *groupDict in groups) {
			FriendGroup *group = [FriendGroup friendGroupWithDictionary:groupDict];
			if(i==0){
				//设置第一个大鹏为展开
				group.opened = YES;
				i++;
			}
			[mgroupsArray addObject:group];
		}
		self.friendGroups = mgroupsArray;
	}
	[_pullTableView reloadData];
}


#pragma mark  加载tableView
- (void)loadTableViewWithRect:(CGRect)theRect style:(UITableViewStyle)style
{
	_pullTableView = [[PullToRefreshTableView alloc] initWithFrame:theRect style:style];
	if (style == UITableViewStyleGrouped) {
		[_pullTableView setBackgroundView:nil];
	}
	//    [_pullTableView setBackgroundView:[[UIView alloc] init]];
	
	[_pullTableView setBackgroundColor:[UIColor clearColor]];
	_pullTableView.delegate = self;
	_pullTableView.dataSource = self;
	[self.view addSubview:_pullTableView];
	_pullTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_pullTableView.isCloseFooter = YES;
	//    _pullTableView.isCloseHeader = YES;
}

#pragma mark 刷新的代理方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	NSInteger returnKey = [_pullTableView tableViewDidEndDragging];
	if (returnKey != k_RETURN_DO_NOTHING) {
		NSString * key = [NSString stringWithFormat:@"%d", returnKey];
		[self updateThread:key];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_pullTableView tableViewDidDragging];
}

- (void)updateTableViewCount:(NSInteger)theCount pageSize:(NSInteger)size
{
	BOOL status = NO;
	NSInteger totalCount = size;
	if (size == 0) {
		totalCount = (int)PageSize;
	} else if (size == -1) {//网络问题失败
		status = YES;
	}
	
	if (theCount < totalCount) {//小于
		status = YES;
	}
	if (theCount != 0) {
		_pullTableView.isCloseFooter = !status;
	}
	
	if (status) {//还有数据
		// 一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
		[_pullTableView reloadData:NO];
	} else {//没有数据
		//  一定要调用本方法，否则下拉/上拖视图的状态不会还原，会一直转菊花
		[_pullTableView reloadData:YES];
	}
}


#pragma mark 刷新
-(void)getData
{
	[self updateTableViewCount:0 pageSize:0];
}

#pragma mark 加载
- (void)nextPage
{
	[self updateTableViewCount:0 pageSize:0];
}

- (void)updateThread:(NSString *)returnKey{
	switch ([returnKey intValue]) {
		case k_RETURN_REFRESH:
			//            [data removeAllObjects];
			[self getData];
			break;
		case k_RETURN_LOADMORE:
			[self nextPage];
			break;
		default:
			break;
	}
}

- (void)ScanZcode:(NSDictionary*)model{
	ScanZcodeVC *control = [[ScanZcodeVC alloc]init];
	control.delegate = self;
	[self presentViewController:control animated:NO completion:nil];
}

- (void)passValue:(NSString*)value{
	[self.addDevice passValue:value];
	[self.addDevice removeFromSuperview];
	[self.view addSubview:self.addDevice];
}

#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	[self initDataSource:model];
	[SBPublicAlert hideMBprogressHUD:self.view];
	//NSInteger tagRequest = MailList + _type;
	
//	if (tag == tagRequest) {
//		_totalPage = [model[@"tcount"] integerValue];
//		
//		if (_currentPage == kStartPage) {//是第一页
//			[_muArrData removeAllObjects];
//		}
//		NSArray *arr = model[@"list"];
//		[_muArrData addObjectsFromArray:arr];
//		if (_muArrData.count == 0) {
//			[SBPublicAlert showMBProgressHUD:@"没有数据" andWhereView:self.view hiddenTime:kHiddenAlertTime];
//		}
//		[self updateTableViewCount:_muArrData.count pageSize:_totalPage];
//	} else if (tag == DeleteMail) {//删除邮件成功
//		if ([model isKindOfClass:[NSDictionary class]]) {
//			[SBPublicAlert showMBProgressHUD:model[@"resultinfo"] andWhereView:self.view hiddenTime:kHiddenAlertTime];
//		}
//	}
}
- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	if (_pullTableView) {
		[self updateTableViewCount:0 pageSize:0];
	}
	[SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
	//[self pageMinusOne];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
	if (message.length == 0) {
		message = @"请求失败";
	}
	if (_pullTableView) {
		[self updateTableViewCount:0 pageSize:0];
	}
	
	[SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
	//[self pageMinusOne];
}

@end
