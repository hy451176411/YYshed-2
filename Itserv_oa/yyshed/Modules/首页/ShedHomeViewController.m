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



// 遵守FriendHeaderDelegate协议
@interface ShedHomeViewController () <FriendHeaderDelegate,UIWebViewDelegate>

@property(nonatomic, strong) NSArray *friendGroups;
@property (nonatomic, retain) YYNetRequest *theRequest;
@end

@implementation ShedHomeViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	[self.navigationController.navigationBar setBarTintColor:[UIColor greenColor]];
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
	
	//初始化中间部分
	self.tableView.showsVerticalScrollIndicator=NO;
	self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	self.tableView.sectionHeaderHeight = 44;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
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
	FriendCell *cell = [FriendCell cellWithTableView:self.tableView];
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
	FriendHeader *header = [FriendHeader friendHeaderWithTableView:self.tableView];
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
		[self.tableView reloadData];
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
	UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加大棚!" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
	[alter show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	[self.tableView reloadData];
}
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	[self initDataSource:model];

}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	NSLog(@"请求超时");
	[SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
	[SBPublicAlert showMBProgressHUD:message andWhereView:self.view hiddenTime:kHiddenAlertTime];
}

@end
