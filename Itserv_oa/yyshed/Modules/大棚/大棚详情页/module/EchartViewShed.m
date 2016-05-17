//
//  EchartViewShed.m
//  Itserv_oa
//
//  Created by mac on 16/5/14.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "EchartViewShed.h"
#import "PYColor.h"
#import "PYOption.h"
@implementation EchartViewShed

-(void)initDatas{
	NSArray *array = self.model;
	self.data = [NSMutableArray array];
	self.time = [NSMutableArray array];
	for (int i=0; i<array.count; i++) {
		NSDictionary *dic = array[i];
		NSString *value = dic[@"value"];
		NSString *t = [NSString stringWithFormat:@"%i:00",i];
		[self.time addObject:t];
		[self.data addObject:value];
	}
	if ([self.type isEqualToString:@"air_humidity"]) {
		self.title = @"湿度传感器";
	}else if([self.type isEqualToString:@"air_temperature"]) {
		self.title = @"温度传感器";
	}else if([self.type isEqualToString:@"illumination"]) {
		self.title = @"光照传感器";
	}
		
}
- (void)initAll {
	[self initDatas];
	self.kEchartView = [[PYEchartsView alloc] init];
	self.kEchartView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ECHART_H);
	self.kEchartView.backgroundColor = [UIColor whiteColor];
	[self addSubview:self.kEchartView];
	[self initChartView];

}

- (void)initChartView {
	//self.title = @"折线图";
	[self showStandardLineDemo];
	[_kEchartView loadEcharts];
}
/**
 *  标准折线图
 */
-(void)showStandardLineDemo {
	PYOption *option = [[PYOption alloc] init];
	PYTitle *title = [[PYTitle alloc] init];
	title.text = self.title;
	//title.subtext = @"纯属虚构";
	option.title = title;
	PYTooltip *tooltip = [[PYTooltip alloc] init];
	tooltip.trigger = @"axis";
	option.tooltip = tooltip;
	PYGrid *grid = [[PYGrid alloc] init];
	grid.x = @(50);
	grid.x2 = @(20);
	grid.y = @(40);
	option.grid = grid;

	option.calculable = YES;
	PYAxis *xAxis = [[PYAxis  alloc] init];
	xAxis.type = @"category";
	xAxis.boundaryGap = @(NO);
	xAxis.data = self.time;
	option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
	PYAxis *yAxis = [[PYAxis alloc] init];
	yAxis.type = @"value";
	yAxis.axisLabel.formatter = @"{value} ℃";
	option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
	PYSeries *series1 = [[PYSeries alloc] init];
	series1.name = @"最高温度";
	series1.type = @"line";
	series1.data = self.data;
	option.series = [[NSMutableArray alloc] initWithObjects:series1, nil];
	[_kEchartView setOption:option];
}

@end
