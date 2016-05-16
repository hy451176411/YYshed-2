//
//  ShedDatailCenter.m
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDatailCenter.h"

@implementation ShedDatailCenter

-(void)configDataOfCenter:(id)data{
	float width = SCREEN_WIDTH;
	//float Element_h = CAMERA_H+SHUTTER_H+WATER_SHED_H+ELEMENT_SPACING_H*3;
	//一个摄像头的高度，一个卷帘机的高度，一个节水系统的高度，每个的间距为ELEMENT_SPACING_H
	
	float Element_h = CAMERA_H+SHUTTER_H+WATER_SHED_H+ELEMENT_SPACING*3;
	//一个摄像头的高度，一个卷帘机的高度，一个节水系统的高度，每个的间距为ELEMENT_SPACING_H
	
	UIView *rootView = [[UIView alloc] init];
	rootView.frame = CGRectMake(0, 0, width, Element_h);//注意设置frame

	Camera *camera = [[Camera alloc] init];
	[camera initCamera:nil];
	camera.frame = CGRectMake(0, 0, width, CAMERA_H+ELEMENT_SPACING);
	
	Shutter *shutter = [[Shutter alloc] init];
	[shutter initShutter:nil];
	shutter.frame = CGRectMake(0, CAMERA_H+ELEMENT_SPACING*2, width, SHUTTER_H);
	
	ShedWater *water = [[ShedWater alloc] init];
	[water initWater:nil];
	water.frame = CGRectMake(0, CAMERA_H+SHUTTER_H+ELEMENT_SPACING*3, width, WATER_SHED_H);
	
	[rootView addSubview:camera];
	[rootView addSubview:shutter];
	[rootView addSubview:water];
	[self addSubview:rootView];
}
- (void)touchUP:(id)sender
{
	NSLog(@"touchUp ShedDatailCenter");
}

@end
