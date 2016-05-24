//
//  InformationController.m
//  Itserv_oa
//
//  Created by mac on 16/5/23.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "InformationController.h"


@interface InformationController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>
@end

@implementation InformationController

-(void)configureData{
	//从文件读取地址字典
	NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
	self.address = [dict objectForKey:@"address"];
	self.provinces = [NSMutableArray array];
	for (int i=0; i< self.address.count; i++) {
		NSDictionary *province = self.address[i];
		NSString *provinceName = [province objectForKey:@"name"];
		[self.provinces addObject:provinceName];
	}
	self.citys = [NSMutableArray array];
	NSDictionary *province = self.address[0];
	NSArray *CITYS = [province objectForKey:@"sub"];
	for (int i=0; i<CITYS.count; i++) {
		NSDictionary *city = CITYS[i];
		NSString *cityName = [city objectForKey:@"name"];
		[self.citys addObject:cityName];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configureData];
	self.plants = @[@"全部",@"番茄",@"土豆",@"西红柿",@"大米"];
	[self initMenu];
	float ox = self.menu.frame.origin.x;
	[self initBottom];
}
-(void)initBottom{
	self.scrollView = [[UIScrollView alloc] init];
	[self.scrollView setScrollEnabled:YES];
	self.scrollView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
	// 隐藏水平滚动条
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	// 去掉弹簧效果
	self.scrollView.bounces = YES;
	float scrollViewH =SCREEN_HEIGHT - 40-BOTTOM_H-100;
	self.scrollView.frame = CGRectMake(0, 40, SCREEN_WIDTH,scrollViewH );

	self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,scrollViewH+2);
	[self.view addSubview:self.scrollView];
	float colomH = 45;
	float startY = ELEMENT_SPACING;
	float lineTitlew = 120;
	float valuew = SCREEN_WIDTH - ELEMENT_SPACING*2- lineTitlew;
	{
		UIView *palntCountView = [[UIView alloc]init];
		palntCountView.frame = CGRectMake(0, startY, SCREEN_WIDTH, colomH);
		palntCountView.backgroundColor = [UIColor whiteColor];
		UILabel  *palntCountlabel = [[UILabel alloc] init];
		palntCountlabel.frame =CGRectMake(ELEMENT_SPACING, 0, lineTitlew, colomH);
		palntCountlabel.text = @"大棚数：";
		[palntCountView addSubview:palntCountlabel];
		
		UILabel  *palntCountlabelv = [[UILabel alloc] init];
		palntCountlabelv.frame =CGRectMake(ELEMENT_SPACING+lineTitlew, 0, valuew, colomH);
		palntCountlabelv.text = @"20个";
		[palntCountView addSubview:palntCountlabelv];
		startY = startY+colomH+1;
		[self.scrollView addSubview:palntCountView];
	}
	
	{
		startY = startY+1;
		UIView *palntAreaView = [[UIView alloc]init];
		palntAreaView.frame = CGRectMake(0, startY, SCREEN_WIDTH, colomH);
		palntAreaView.backgroundColor = [UIColor whiteColor];
		UILabel  *palntArealabel = [[UILabel alloc] init];
		palntArealabel.frame =CGRectMake(ELEMENT_SPACING, 0, lineTitlew, colomH);
		palntArealabel.text = @"种植面积：";
		[palntAreaView addSubview:palntArealabel];
		
		UILabel  *palntArealabelv = [[UILabel alloc] init];
		palntArealabelv.frame =CGRectMake(ELEMENT_SPACING+lineTitlew, 0, valuew, colomH);
		palntArealabelv.text = @"200平方米";
		[palntAreaView addSubview:palntArealabelv];
		startY = startY+colomH+1;
		[self.scrollView addSubview:palntAreaView];
	}
	
	{
		startY = startY+1;
		UIView *palntAreaView = [[UIView alloc]init];
		palntAreaView.frame = CGRectMake(0, startY, SCREEN_WIDTH, colomH);
		palntAreaView.backgroundColor = [UIColor whiteColor];
		UILabel  *palntArealabel = [[UILabel alloc] init];
		palntArealabel.frame =CGRectMake(ELEMENT_SPACING, 0, lineTitlew, colomH);
		palntArealabel.text = @"预估年产量：";
		[palntAreaView addSubview:palntArealabel];
		
		UILabel  *palntArealabelv = [[UILabel alloc] init];
		palntArealabelv.frame =CGRectMake(ELEMENT_SPACING+lineTitlew, 0, valuew, colomH);
		palntArealabelv.text = @"200公斤";
		[palntAreaView addSubview:palntArealabelv];
		startY = startY+colomH+1;
		[self.scrollView addSubview:palntAreaView];
	}
	
	{
		startY = startY+1;
		UIView *palntAreaView = [[UIView alloc]init];
		palntAreaView.frame = CGRectMake(0, startY, SCREEN_WIDTH, colomH);
		palntAreaView.backgroundColor = [UIColor whiteColor];
		UILabel  *palntArealabel = [[UILabel alloc] init];
		palntArealabel.frame =CGRectMake(ELEMENT_SPACING, 0, lineTitlew, colomH);
		palntArealabel.text = @"预估收获期：";
		[palntAreaView addSubview:palntArealabel];
		
		UILabel  *palntArealabelv = [[UILabel alloc] init];
		palntArealabelv.frame =CGRectMake(ELEMENT_SPACING+lineTitlew, 0, valuew, colomH);
		palntArealabelv.text = @"无信息";
		[palntAreaView addSubview:palntArealabelv];
		startY = startY+colomH+1;
		[self.scrollView addSubview:palntAreaView];
	}
}
-(void)initMenu{
	self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
	//self.menu.frame = CGRectMake(0, 0, 200, 40);
	self.menu.dataSource = self;
	self.menu.delegate = self;
	[self.view addSubview:self.menu];
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dismiss:(UIBarButtonItem *)sender {
	[self.menu dismiss];
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
	return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
	if (column == PROVINCE_COMPONENT) {
		return self.provinces.count;
	}
	else if (column == CITY_COMPONENT) {
		return self.citys.count;
	}
	else {
		return self.plants.count;
	}
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
	switch (indexPath.column) {
		case 0: return self.provinces[indexPath.row];
			break;
		case 1:{
			NSString *city = self.citys[indexPath.row];
			return city;
			}
			break;
		case 2: return self.plants[indexPath.row];
			break;
		default:
			return nil;
			break;
	}
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
	switch (indexPath.column) {
		case 0:{
			int index = indexPath.row;
			int row = indexPath.column;
			self.citys.removeAllObjects;
			NSDictionary *province = self.address[index];
			NSArray *CITYS = [province objectForKey:@"sub"];
			for (int i=0; i<CITYS.count; i++) {
				NSDictionary *city = CITYS[i];
				NSString *cityName = [city objectForKey:@"name"];
				[self.citys addObject:cityName];
			}
			/*方法一：从父亲的view中间去掉menu，然后再加上，不成功刷新menu的选择状态*/
			//[self.menu removeFromSuperview];
			//[self.view addSubview:self.menu];
			/*方法二：手动刷新*/
//			DOPIndexPath *path = [[DOPIndexPath alloc] init];
//			path.column =1;
//			path.row=0;
//			[self menu:menu titleForRowAtIndexPath:path];
//			[self menu:menu didSelectRowAtIndexPath:path];
			/*方法三：重新创建menu，重新添加，成功刷新*/
			[self.menu removeFromSuperview];
			[self initMenu];
		}
		break;
		case 1:{
			
		}
			break;
		case 2:{
			
		}
			
		default:
			break;
	}

}
@end
