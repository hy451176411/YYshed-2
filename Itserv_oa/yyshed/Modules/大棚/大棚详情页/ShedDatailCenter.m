//
//  ShedDatailCenter.m
//  Itserv_oa
//
//  Created by mac on 16/5/11.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "ShedDatailCenter.h"

@implementation ShedDatailCenter
-(void)initModel{
	self.cameraModel=[NSMutableArray array];
	self.waterModel=[NSMutableArray array];
	self.shutterModel=[NSMutableArray array];
	NSMutableArray *tempCamera = [NSMutableArray array];
	NSMutableArray *tempwater = [NSMutableArray array];
	NSMutableArray *tempshutter = [NSMutableArray array];
	NSArray *array = self.rootModel;
	for (int i=0; i<array.count; i++) {
		NSDictionary *dic = array[i];
		if (dic) {
			NSString *dev_type = dic[@"dev_type"];
			if ([dev_type isEqualToString:@"cameraip"]) {
				[tempCamera addObject:dic];
			}else if ([dev_type isEqualToString:@"erelay"]) {
				[tempwater addObject:dic];
			} else if ([dev_type isEqualToString:@"erelay2"]) {
				[tempshutter addObject:dic];
			}
		}
	}
	self.cameraModel= tempCamera;
	self.waterModel= tempwater;
	self.shutterModel= tempshutter;
	//NSMutableArray *temp = self.cameraModel;
}

-(float)configDataOfCenter:(id)data{
	[self initModel];
	//self.backgroundColor = [UIColor redColor];
	float width = SCREEN_WIDTH;
	//float Element_h = CAMERA_H+SHUTTER_H+WATER_SHED_H+ELEMENT_SPACING_H*3;
	//一个摄像头的高度，一个卷帘机的高度，一个节水系统的高度，每个的间距为ELEMENT_SPACING_H
	float cameraH= 0;
	float  waterH = 0;
	float shutterH= 0;
	if (self.cameraModel) {
		cameraH = CAMERA_H*self.cameraModel.count;
	}
	if (self.waterModel) {
		waterH = WATER_SHED_H*self.waterModel.count;
	}
	if (self.shutterModel) {
		shutterH = SHUTTER_H*self.shutterModel.count;
	}
	
	float elementH = ELEMENT_SPACING*(self.cameraModel.count+self.waterModel.count+self.shutterModel.count);
	float Element_h = cameraH+waterH+shutterH+elementH;
	//一个摄像头的高度，一个卷帘机的高度，一个节水系统的高度，每个的间距为ELEMENT_SPACING_H
	
	UIView *rootView = [[UIView alloc] init];
	rootView.frame = CGRectMake(0, 0, width, Element_h);//注意设置frame
	float startY = ELEMENT_SPACING;
	if (cameraH>0) {
		for (int i=0; i<self.cameraModel.count; i++) {
			NSDictionary *cameraDic = self.cameraModel[i];
			Camera *camera = [[Camera alloc] init];
			camera.model = cameraDic;
			[camera initCamera:nil];
			camera.frame = CGRectMake(0, startY, width, CAMERA_H);
			[rootView addSubview:camera];
			startY = startY+CAMERA_H+ELEMENT_SPACING;
		}
		
	}

	if (shutterH>0) {
		for (int i=0; i<self.shutterModel.count; i++) {
			NSDictionary *shutterDic = self.shutterModel[i];
			Shutter *shutter = [[Shutter alloc] init];
			shutter.model = shutterDic;
			shutter.delegate = self.delegate;
			[shutter initShutter:nil];
			shutter.frame = CGRectMake(0, startY, width, SHUTTER_H);
			[rootView addSubview:shutter];
			startY = startY+SHUTTER_H+ELEMENT_SPACING;
		}
	}

	if (waterH>0) {
		for (int i=0; i<self.waterModel.count; i++) {
			NSDictionary *waterDic = self.waterModel[i];
			ShedWater *water = [[ShedWater alloc] init];
			water.delegate = self.delegate;
			water.model = waterDic;
			[water initWater:nil];
			water.frame = CGRectMake(0, startY, width, WATER_SHED_H);
			[rootView addSubview:water];
			startY = startY+WATER_SHED_H+ELEMENT_SPACING;
		}
		
	}
	
	[self addSubview:rootView];
	return Element_h;
}
- (void)touchUP:(id)sender
{
	NSLog(@"touchUp ShedDatailCenter");
}

@end
