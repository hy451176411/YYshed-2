//
//  ShedHomeViewController.m
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedHomeViewController.h"
#import "Friend.h"
#import "FriendGroup.h"
#import "FriendCell.h"
#import "FriendHeader.h"

// 遵守FriendHeaderDelegate协议
@interface ShedHomeViewController () <FriendHeaderDelegate>

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
	[self initDataSource];
}
- (BOOL)prefersStatusBarHidden {
	return YES;
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
	// 刷新数据
	[self.tableView reloadData];
}


-(void)rightBtnClick{
	UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加大棚!" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
	[alter show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initDataSource
{
	NSDictionary *dic02=[NSDictionary dictionaryWithObjectsAndKeys:@"001.png",@"icon",@"不要命的工作",@"intro",@"黄晓明",@"name",@"1",@"vip", nil];
	NSArray *friends1=[NSArray arrayWithObjects:dic02, nil];
	
	NSDictionary *datas =[NSDictionary dictionaryWithObjectsAndKeys:@"我的好友",@"name",@"1",@"online",friends1,@"friends", nil];
	self.groupsArray = [NSArray arrayWithObjects:datas,nil];
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	[_theRequest getUserInfo:session_token user_Agent:@"test"];
}
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);

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
