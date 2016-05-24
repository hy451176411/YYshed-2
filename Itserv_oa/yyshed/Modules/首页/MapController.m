//
//  MapController.m
//  Itserv_oa
//
//  Created by mac on 16/5/23.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "MapController.h"

@interface MapController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>
@end

@implementation MapController

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
}

-(void)initMenu{
	float buttonW = 50;
	float w = SCREEN_WIDTH - buttonW-5;
	float menuH = 40;
	float buttonH =25;
	self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:menuH andWidth:w];
	
	UIButton *_btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
	_btnBack.frame = CGRectMake(w, (menuH-buttonH)/2, buttonW, buttonH);
	_btnBack.backgroundColor = [UIColor greenColor];
	_btnBack.titleLabel.font = SystemFontOfSize(16);
	//[_btnBack setImage:[UIImage imageNamed:@"button5.png"] forState:UIControlStateNormal];
	[_btnBack setTitle:@"查询" forState:UIControlStateNormal];
	//[_btnBack addTarget:self action:@selector(searchPlant:) forControlEvents:UIControlEventTouchUpInside];
	
	self.menu.dataSource = self;
	self.menu.delegate = self;
	[self.view addSubview:self.menu];
	[self.view addSubview:_btnBack];
	
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
