//
//  ShedDetailBottom.m
//  Itserv_oa
//
//  Created by mac on 16/5/15.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDetailBottom.h"

@interface ShedDetailBottom ()
@end

@implementation ShedDetailBottom

-(float)configDataOfBottom:(id)data{
	
	UIView *rootView = [[UIView alloc] init];
	rootView.frame = CGRectMake(0, 0, SCREEN_WIDTH, ECHART_H);//注意设置
	float startY = 0;
	NSDictionary *chartData = self.model;
	NSArray *air_temperature = chartData[@"air_temperature"];
	
	if (air_temperature) {
		if (air_temperature && air_temperature.count>0) {
			EchartViewShed *echart =	[[EchartViewShed alloc] init];
			echart.model = air_temperature;
			echart.type = @"air_temperature";
			[echart initAll];
			echart.frame = CGRectMake(0,startY, SCREEN_WIDTH, ECHART_H);
			[rootView addSubview:echart];
			startY =startY +ECHART_H+ELEMENT_SPACING;
		}
	
	}
	
	NSArray *air_humidity = chartData[@"air_humidity"];
	if (air_humidity) {
		if (air_humidity && air_humidity.count>0) {
			EchartViewShed *echart =	[[EchartViewShed alloc] init];
			echart.model = air_humidity;
			echart.type = @"air_humidity";
			[echart initAll];
			echart.frame = CGRectMake(0,startY, SCREEN_WIDTH, ECHART_H);
			[rootView addSubview:echart];
			startY =startY +ECHART_H+ELEMENT_SPACING;
		}
	}
	NSArray *illumination = chartData[@"lux"];
	if (illumination) {
		if (illumination && illumination.count>0) {
			EchartViewShed *echart =	[[EchartViewShed alloc] init];
			echart.model = illumination;
			echart.type = @"illumination";
			[echart initAll];
			echart.frame = CGRectMake(0,startY, SCREEN_WIDTH, ECHART_H);
			[rootView addSubview:echart];
			startY =startY +ECHART_H+ELEMENT_SPACING;
		}
	}
	[self addSubview:rootView];
	return startY;
	
}


@end
