//
//  ShedSettingVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/18.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedSettingVC.h"
#import "CommonShed.h"
#import "ShedAliasCell.h"
#import "ShedSensorCell.h"
@interface ShedSettingVC ()<UITableViewDataSource,UITableViewDelegate,ShedAliasCellDelegate,ShedSensorCellDelegate>
{
	UITableView *personalTableView;
	//NSArray *dataSource;
	Boolean isFirstEnter;//第一进入底部会留有高度
}

@end

@implementation ShedSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
	isFirstEnter = YES;
	self.modules = [NSMutableArray array];
	self.rootView = [[UIView alloc] init];
	[self.view addSubview:self.rootView];
	[self initSegmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
	
	NSInteger Index = Seg.selectedSegmentIndex;
	
	switch (Index)
	{
		case 0:
			[self firstViewEnter];
			break;
		case 1:
			[self secoendView];
			break;
		case 2:
			[self thirdView];
			break;
		default:
			break;
	}
}
-(void)thirdView{
	[self.rootView removeAllSubviews];
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.image = [UIImage imageNamed:@"back.png"];
	imageView.frame = CGRectMake(80, 80, 40, 40);
	[self.rootView addSubview:imageView];
	//self.view.backgroundColor = [UIColor redColor];
	[self.view addSubview:self.rootView];
}
-(void)secoendView{
	[self.rootView removeAllSubviews];
//	// 1.创建UIScrollView
	self.scrollView = [[UIScrollView alloc] init];
	CGRect rect =[[UIScreen mainScreen] bounds];
	float h = rect.size.height;
	self.scrollView.frame = CGRectMake(0, 0, rect.size.width, h-60);
	//self.scrollView.backgroundColor = [UIColor grayColor];
	// 2.创建UIImageView（图片）
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.image = [UIImage imageNamed:@"back.png"];
	imageView.frame = CGRectMake(80, 80, 40, 40);
	UITextField *textFile = [[UITextField alloc] init];
	textFile.frame =CGRectMake(80, 150, 200, 40);
	textFile.text = @"text";
	[textFile setKeyboardType:UIKeyboardTypeDefault];
	[self.scrollView addSubview:textFile];
	[self.scrollView addSubview:imageView];
	[self.scrollView setScrollEnabled:YES];
	self.scrollView.contentSize = CGSizeMake(rect.size.width, 2000);
	// 隐藏水平滚动条
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	// 去掉弹簧效果
	self.scrollView.bounces = YES;
	[self.rootView addSubview:self.scrollView];
	self.rootView.frame = CGRectMake(0, 60, rect.size.width, 2000);
	
}
-(void)FirstView{
	CGRect rect = self.view.frame;
	float h = 0 ;
	//if (isFirstEnter) {
	//	isFirstEnter = NO;
	//	h = rect.size.height-SEGMENT_SETTING_H-3*ELEMENT_SPACING-BOTTOM_H-105;
	//}else{
		h=rect.size.height-SEGMENT_SETTING_H-3*ELEMENT_SPACING-BOTTOM_H;
	//}
	personalTableView=[[UITableView alloc]initWithFrame:CGRectMake(ELEMENT_SPACING, 0, SCREEN_WIDTH-2*ELEMENT_SPACING,h) style:UITableViewStylePlain];
	//personalTableView.backgroundColor = [UIColor blueColor];
	personalTableView.delegate=self;
	personalTableView.dataSource=self;
	//personalTableView.bounces=NO;
	personalTableView.showsVerticalScrollIndicator=NO;
	personalTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	personalTableView.delegate = self;
	personalTableView.dataSource = self;
	[self.rootView removeAllSubviews];
	[self.rootView addSubview:personalTableView];
	float startY = 100+(self.modules.count-1)*131 + SEGMENT_SETTING_H +3*ELEMENT_SPACING+BOTTOM_H+100;
	self.rootView.frame = CGRectMake(0, SEGMENT_SETTING_H+2*ELEMENT_SPACING, rect.size.width, startY);
}

#pragma mark - dataSource方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.modules.count;
}
-(void)firstViewEnter{
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	[self.theRequest getDeviceInfo:session_token withDev_id:self.dev_id];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//UITableViewCell *cell;
	//FriendGroup *group = self.friendGroups[indexPath.section];
	//cell.friendData = group.friends[indexPath.row];
	//int i = indexPath.row;
	if (indexPath.row==0) {
	ShedAliasCell *cell = [ShedAliasCell cellWithTableView:personalTableView];
		cell.delegate = self;
		cell.module = self.modules[indexPath.row];
		return cell;
	}else{
		ShedSensorCell *cell = [ShedSensorCell cellWithTableView:personalTableView];
		cell.delegate = self;
		cell.module = self.modules[indexPath.row];
		return cell;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float h = 131;
	if (indexPath.row==0) {
		h =131;
	}else{
		h=100;
	}
	return h;
}

- (void)initSegmentedControl
{
	NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"别名设置",@"报警预案设置",@"其他设置",nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
	float width = SCREEN_WIDTH - 2*ELEMENT_SPACING;
	segmentedControl.frame = CGRectMake(ELEMENT_SPACING, ELEMENT_SPACING,width, SEGMENT_SETTING_H);
	/*
	 这个是设置按下按钮时的颜色
	 */
	segmentedControl.tintColor = [UIColor colorWithRed:49.0 / 256.0 green:148.0 / 256.0 blue:208.0 / 256.0 alpha:1];
	segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
	/*
	 下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
	 */
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor redColor], NSForegroundColorAttributeName, nil];
	[segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
	NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
	[segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
	//设置分段控件点击相应事件
	[segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:segmentedControl];
	[self firstViewEnter];
}

- (void) updateShedAlias:(NickNameModule *) module{
	NSLog(@"updateShedAlias");
}

- (void) updateShedSensorAlias:(NickNameModule *) module{
	NSLog(@"updateShedSensorAlias");
}
-(void)initViewsWithDatas:(NSDictionary *)model{
	self.modules = [NSMutableArray array];
	NSDictionary *smartgate = model[@"smartgate"];
	NickNameModule *module = [[NickNameModule alloc] init];
	module.alias = smartgate[@"dev_name"];
	[self.modules addObject:module];
	NSArray *components = model[@"components"];
	for (int i=0; i<components.count; i++) {
		NSDictionary *dic = components[i];
		NickNameModule *module = [[NickNameModule alloc] init];
		module.alias = dic[@"dev_name"];
		module.sn = dic[@"sn"];
		[self.modules addObject:module];
	}
	[self FirstView];
}
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	if (tag == YYShed_getDeviceInfo) {
		[self initViewsWithDatas:model];
	}
	
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
