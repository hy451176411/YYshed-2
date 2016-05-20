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
#import "AlarmStratey.h"
#import "AlarmStrategyView.h"
#import "AlarmStrateyItem.h"
@interface ShedSettingVC ()<UITableViewDataSource,UITableViewDelegate,ShedAliasCellDelegate,ShedSensorCellDelegate,StrategyMenuDelegate>
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
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
	self.modules = [NSMutableArray array];
	self.rootView = [[UIView alloc] init];
	[self.view addSubview:self.rootView];
	[self initSegmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark 其他设置
-(void)thirdView{
	[self.rootView removeAllSubviews];
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.image = [UIImage imageNamed:@"back.png"];
	imageView.frame = CGRectMake(80, 80, 40, 40);
	[self.rootView addSubview:imageView];
	//self.view.backgroundColor = [UIColor redColor];
	[self.view addSubview:self.rootView];
}
#pragma mark 报警预案设置
-(void)secoendView{
	[self.rootView removeAllSubviews];
	CGRect rect =self.view.frame;
	float h = rect.size.height;
	self.scrollView = [[UIScrollView alloc] init];
	[self.scrollView setScrollEnabled:YES];
	// 隐藏水平滚动条
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	// 去掉弹簧效果
	self.scrollView.bounces = YES;
	[self.rootView addSubview:self.scrollView];
	self.rootView.frame = CGRectMake(0, 60, rect.size.width, h-MENU_H);
	
	self.scrollView.frame = CGRectMake(0, 0, rect.size.width, h-MENU_H-2*ELEMENT_SPACING);
	self.startY = 0;
	float headerH =50;
	float W =rect.size.width-2*ELEMENT_SPACING;
	UIView *headerView = [[UIView alloc] init];
	headerView.frame = CGRectMake(ELEMENT_SPACING, self.startY,W , headerH);
	
	float applyAndRefreshW_H = 40;
	UILabel  *headerTip = [[UILabel alloc] init];
	headerTip.frame =CGRectMake(0, 0, 200, 45);
	headerTip.text = @"报警预案";
	headerTip.font = SystemFontOfSize(24);
	[headerView addSubview:headerTip];
	
	UIImageView *refresh = [[UIImageView alloc] init];//刷新按钮
	refresh.image = [UIImage imageNamed:@"refresh.png"];
	refresh.frame = CGRectMake(W-2*applyAndRefreshW_H-ELEMENT_SPACING, (headerH-applyAndRefreshW_H)/2, applyAndRefreshW_H, applyAndRefreshW_H);//(headerH-applyAndRefreshW_H)/2 header区域的高度减去按钮的高度，除以2，让按钮居中显示
	[headerView addSubview:refresh];
	
	UIImageView *apply = [[UIImageView alloc] init];//应用按钮
	apply.image = [UIImage imageNamed:@"apply.png"];
	apply.frame = CGRectMake(W-applyAndRefreshW_H, (headerH-applyAndRefreshW_H)/2, applyAndRefreshW_H, applyAndRefreshW_H);
	[headerView addSubview:apply];
	[self.scrollView addSubview:headerView];
	self.startY = self.startY+headerH+ELEMENT_SPACING;
	
	StrategyMenu *menu = [[StrategyMenu alloc] init];
	//NSMutableArray *menus = [self configMenus:model[@"components"]];
	//menu.menus = menus;
	NSArray *menus = [NSArray arrayWithObjects:@"<未设置报警策略>",@"西红柿种植预案(自定义策略)",nil];
	menu.menus = menus;
	float menuH = [menu configDataOfBottomMenu:nil];
	menu.frame = CGRectMake(ELEMENT_SPACING, self.startY,W, MENU_H);
	menu.delegate = self;
	[self.scrollView addSubview:menu];
	self.startY = self.startY +menuH +ELEMENT_SPACING;
	//添加一个数据
	self.mAllAlarmStratey = [NSMutableArray array];
	AlarmStratey *noStratey = [[AlarmStratey alloc] init];
	noStratey.strategy_name = @"<未设置报警策略>";
	[self.mAllAlarmStratey addObject:noStratey];
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	[self.theRequest getShedStrategy:session_token withDevUuid:self.dev_id];
	self.scrollView.contentSize = CGSizeMake(rect.size.width, self.startY);

}
-(void)initSecendView:(NSDictionary*)model{
	AlarmStrateyItem *test = [[AlarmStrateyItem alloc] init];
	NSArray *array = model;
	NSDictionary *model1 = array[0];
	AlarmStratey *alarmStatey = [[AlarmStratey alloc] init];
	[alarmStatey initAlarmStratey:model1];
	if (alarmStatey) {
		AlarmStrategyView *alarmStateyView = [[AlarmStrategyView alloc] init];
		float h = [alarmStateyView showAlarmStrategyView:alarmStatey];
		alarmStateyView.frame =CGRectMake(ELEMENT_SPACING, self.startY,SCREEN_WIDTH , h);
		self.startY = self.startY+h;
		[self.scrollView addSubview:alarmStateyView];
		self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.startY+BOTTOM_H+ELEMENT_SPACING);
	}
}
/*报警预案设置中间的预案名称的选择器返回*/
- (void)didConfirmWithItemAtRow:(NSDictionary*)model{
	NSLog(@"didConfirmWithItemAtRow %@",model);
}
//-(void)secoendView{
//	[self.rootView removeAllSubviews];
////	// 1.创建UIScrollView
//	self.scrollView = [[UIScrollView alloc] init];
//	CGRect rect =self.view.frame;
//	float h = rect.size.height;
//	self.scrollView.frame = CGRectMake(0, 0, rect.size.width, h-MENU_H);
//	UIImageView *imageView = [[UIImageView alloc] init];
//	imageView.image = [UIImage imageNamed:@"back.png"];
//	imageView.frame = CGRectMake(80, 80, 40, 40);
//	UITextField *textFile = [[UITextField alloc] init];
//	textFile.frame =CGRectMake(80, 150, 200, 40);
//	textFile.text = @"text";
//	UILabel  *label = [[UILabel alloc] init];
//	label.frame =CGRectMake(80, 800-40-BOTTOM_H-10, 200, 40);
//	label.backgroundColor = [UIColor redColor];
//	label.text = @"底部测试";
//	[self.scrollView addSubview:label];
//	[textFile setKeyboardType:UIKeyboardTypeDefault];
//	[self.scrollView addSubview:textFile];
//	[self.scrollView addSubview:imageView];
//	[self.scrollView setScrollEnabled:YES];
//	self.scrollView.contentSize = CGSizeMake(rect.size.width, 800);
//	// 隐藏水平滚动条
//	self.scrollView.showsHorizontalScrollIndicator = NO;
//	self.scrollView.showsVerticalScrollIndicator = NO;
//	// 去掉弹簧效果
//	self.scrollView.bounces = YES;
//	[self.rootView addSubview:self.scrollView];
//	self.rootView.frame = CGRectMake(0, 60, rect.size.width, h-MENU_H);
//
//}


#pragma mark SegmentedControl初始化
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

#pragma mark 别名设置
/*获取大棚数据，取出控制器，分别是要设置别名的传感器列表*/
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
	personalTableView.delegate=self;
	personalTableView.dataSource=self;
	personalTableView.showsVerticalScrollIndicator=NO;
	personalTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
	personalTableView.delegate = self;
	personalTableView.dataSource = self;
	[self.rootView removeAllSubviews];
	[self.rootView addSubview:personalTableView];
	float startY = 100+(self.modules.count-1)*131 + SEGMENT_SETTING_H +3*ELEMENT_SPACING+BOTTOM_H+100;
	self.rootView.frame = CGRectMake(0, SEGMENT_SETTING_H+2*ELEMENT_SPACING, rect.size.width, startY);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.modules.count;
}
/*别名设置的入口，需要获取数据*/
-(void)firstViewEnter{
	NSString *session_token = [UserDefaults stringForKey:YYSession_token];
	[self.theRequest getDeviceInfo:session_token withDev_id:self.dev_id];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
/*更新大棚的别名*/
- (void) updateShedAlias:(NickNameModule *) module{
	NSLog(@"updateShedAlias");
}
/*更新大棚传感器的别名*/
- (void) updateShedSensorAlias:(NickNameModule *) module{
	NSLog(@"updateShedSensorAlias");
}

#pragma mark 网络请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	if (tag == YYShed_getDeviceInfo) {
		[self initViewsWithDatas:model];
	}else if(tag == YYShed_getShedStrategy){
		[self initSecendView:model];
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
