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

typedef enum {
	LineDemoTypeBtnTagStandardLine = 10000,
	LineDemoTypeBtnTagStackedLine = 10001,
	LineDemoTypeBtnTagBasicLine = 10002,
	LindDemoTypeBtnTagBasicArea = 10003,
	LindDemoTypeBtnTagStackedArea = 10004,
	LindDemoTypeBtnTagIrregularLine = 10005,
	LineDemoTypeBtnTagIrregularLine2 = 10006,
	LineDemoTypeBtnTagLine = 10007,
	LineDemoTypeBtnTagLogarithmic = 10008
}LineDemoTypeBtnTag;
@implementation EchartViewShed

- (void)initAll {
	
	self.kEchartView = [[PYEchartsView alloc] init];
	self.kEchartView.frame = CGRectMake(0, ELEMENT_SPACING, SCREEN_WIDTH, ECHART_H);
	self.kEchartView.backgroundColor = [UIColor whiteColor];
	[self addSubview:self.kEchartView];
	[self initData];

}

- (void)initData {
	//self.title = @"折线图";
	[self showStandardLineDemo];
	[_kEchartView loadEcharts];
	//self.kEchartView.backgroundColor = [UIColor grayColor];
}
/**
 *  标准折线图
 */
-(void)showStandardLineDemo {
	PYOption *option = [[PYOption alloc] init];
	PYTitle *title = [[PYTitle alloc] init];
	//title.text = @"未来一周气温变化";
	title.subtext = @"纯属虚构";
	option.title = title;
	PYTooltip *tooltip = [[PYTooltip alloc] init];
	tooltip.trigger = @"axis";
	option.tooltip = tooltip;
	PYGrid *grid = [[PYGrid alloc] init];
	grid.x = @(50);
	//grid.y = @(50);
	grid.x2 = @(20);
	option.grid = grid;
	//    PYLegend *legend = [[PYLegend alloc] init];
	//    legend.data = @[@"最高温度"];
	//    option.legend = legend;
	//    PYToolbox *toolbox = [[PYToolbox alloc] init];
	//    toolbox.show = YES;
	//    toolbox.x = @"right";
	//    toolbox.y = @"top";
	//    toolbox.z = @(100);
	//    toolbox.feature.mark.show = YES;
	//    toolbox.feature.dataView.show = YES;
	//    toolbox.feature.dataView.readOnly = NO;
	//    toolbox.feature.magicType.show = YES;
	//    toolbox.feature.magicType.type = @[@"line", @"bar"];
	//    toolbox.feature.restore.show = YES;
	//    toolbox.feature.saveAsImage.show = YES;
	//    option.toolbox = toolbox;
	option.calculable = YES;
	PYAxis *xAxis = [[PYAxis  alloc] init];
	xAxis.type = @"category";
	xAxis.boundaryGap = @(NO);
	xAxis.data = @[@"1",@"2",@"3",@"4"];
	option.xAxis = [[NSMutableArray alloc] initWithObjects:xAxis, nil];
	PYAxis *yAxis = [[PYAxis alloc] init];
	yAxis.type = @"value";
	yAxis.axisLabel.formatter = @"{value} ℃";
	option.yAxis = [[NSMutableArray alloc] initWithObjects:yAxis, nil];
	PYSeries *series1 = [[PYSeries alloc] init];
	series1.name = @"最高温度";
	series1.type = @"line";
	series1.data = @[@(11),@(11),@(15),@(13),@(1000),@(13),@(10),@(11),@(11),@(15),@(13),@(12),@(13),@(10)];
	//    PYMarkPoint *markPoint = [[PYMarkPoint alloc] init];
	//    markPoint.data = @[@{@"type" : @"max", @"name": @"最大值"},@{@"type" : @"min", @"name": @"最小值"}];
	//    series1.markPoint = markPoint;
	//    PYMarkLine *markLine = [[PYMarkLine alloc] init];
	//    markLine.data = @[@{@"type" : @"average", @"name": @"平均值"}];
	//    series1.markLine = markLine;
	//    PYSeries *series2 = [[PYSeries alloc] init];
	//    series2.name = @"最低温度";
	//    series2.type = @"line";
	//    series2.data = @[@(1),@(-2),@(2),@(5),@(3),@(2),@(0)];
	//    PYMarkPoint *markPoint2 = [[PYMarkPoint alloc] init];
	//    markPoint2.data = @[@{@"value" : @(2), @"name": @"周最低", @"xAxis":@(1), @"yAxis" : @(-1.5)}];
	//    series2.markPoint = markPoint2;
	//    PYMarkLine *markLine2 = [[PYMarkLine alloc] init];
	//    markLine2.data = @[@{@"type" : @"average", @"name": @"平均值"}];
	//    series2.markLine = markLine2;
	option.series = [[NSMutableArray alloc] initWithObjects:series1, nil];
	[_kEchartView setOption:option];
}

@end
