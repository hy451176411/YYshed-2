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
	for (int i=0; i<2; i++) {
		EchartViewShed *echart =	[[EchartViewShed alloc] init];
		[echart initAll];
		echart.frame = CGRectMake(0,startY, SCREEN_WIDTH, ECHART_H);
		[rootView addSubview:echart];
		startY =startY +ECHART_H+ELEMENT_SPACING;
	}
	[self addSubview:rootView];
	return startY;
	
}


@end
