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
	UIView *rootView = [[UIView alloc] init];
	Camera *camera = [[Camera alloc] init];
	[camera initCamera:nil];
	
	Camera *camera2 = [[Camera alloc] init];
	[camera2 initCamera:nil];
	camera2.frame = CGRectMake(0, 235, width, 230);
	[rootView addSubview:camera];
	[rootView addSubview:camera2];
	[self addSubview:rootView];
}

- (void)touchUP
{
	if (_delegate && [_delegate respondsToSelector:@selector(up)]) {
		[_delegate up];
	}
}
@end