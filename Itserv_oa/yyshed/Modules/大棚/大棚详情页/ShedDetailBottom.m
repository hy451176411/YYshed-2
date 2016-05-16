//
//  ShedDetailBottom.m
//  Itserv_oa
//
//  Created by mac on 16/5/15.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDetailBottom.h"
#import "JSDropDownMenu.h"
@interface ShedDetailBottom ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
	
	NSMutableArray *_data1;
	NSInteger _currentData1Index;
	NSInteger _currentData1SelectedIndex;
	JSDropDownMenu *menu;
}
@end


@implementation ShedDetailBottom

-(void)configDataOfBottom:(id)data  withY:(float) orignY{
	
	UIView *rootView = [[UIView alloc] init];
	rootView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ECHART_H+80);//注意设置
	
	EchartViewShed *echart =	[[EchartViewShed alloc] init];
	[echart initAll];
	echart.frame = CGRectMake(0, 0, SCREEN_WIDTH, ECHART_H);
	
	float menuW = SCREEN_WIDTH-2*ELEMENT_SPACING;
	// 指定默认选中
	_currentData1Index = 0;
	_currentData1SelectedIndex = 0;
	_data1 = [NSMutableArray arrayWithObjects:@"温湿度传感器",@"光照传感器",nil];
	menu = [[JSDropDownMenu alloc] initWithOrigin1:CGPointMake(10, orignY) withWidth:menuW andHeight:MENU_H];
	menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
	menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
	menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
	menu.dataSource = self;
	menu.delegate = self;
	menu.frame = CGRectMake(10, 5, menuW, MENU_H);
	//self.backgroundColor = [UIColor grayColor];
	
	[rootView addSubview:echart];
	[rootView addSubview:menu];

	[self addSubview:rootView];
	
}
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
	
	return 1;
}



-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
	
	
	return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
	return 1;
}



- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
	
	if (column==0) {
		return _data1.count;
	}
	return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
	
	switch (column) {
		case 0: return _data1[_currentData1Index];
			
			break;
			
		default:
			return nil;
			break;
	}
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
	
	if (indexPath.column==0) {
		return _data1[indexPath.row];
	}
	return 0;
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
	
	if (indexPath.column == 0) {
		
		_currentData1Index = indexPath.row;
		
	}
}

@end
