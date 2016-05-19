//
//  AlarmStrategyView.m
//  Itserv_oa
//
//  Created by mac on 16/5/19.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "AlarmStrategyView.h"

@implementation AlarmStrategyView

-(float)showAlarmStrategyView:(id)data{
	self.userInteractionEnabled = YES;
	AlarmStratey *alarmAtratey = data;
	NSArray *array = alarmAtratey.strategyitems;
	float startY = 0;
	float Y = 0;
	for (int i=0; i<array.count; i++) {
		AlarmStrateyItem *item = array[i];
		Boolean flag = [self isHighOrLowEnable:item];
		if (flag) {
			startY = [self initStrategyItem:item withH:Y];
			Y=Y+startY+ELEMENT_SPACING;
		}
	}

	return Y;
}
/*判断是否有值设置了*/
-(Boolean)isHighOrLowEnable:(AlarmStrateyItem*)model{
	NSMutableArray *high_alarms = model.high_alarms;
	NSMutableArray *low_alarms = model.low_alarms;
	Boolean flag = NO;
	for (int i=0; i<3; i++) {
		Alarm *alarmL = low_alarms[i];
		if (alarmL.enable) {
			flag = YES;
			break;
		}
		Alarm *alarmH = high_alarms[i];
		if (alarmH.enable) {
			flag = YES;
			break;
		}
	}
	return flag;
}
-(float)initStrategyItem:(NSDictionary*)data withH:(float)startY{
	//float startY = jiebieY;
	float width = SCREEN_WIDTH;
	UIView *rootView1 = [[UIView alloc] init];
	rootView1.userInteractionEnabled = YES;
	rootView1.backgroundColor = [UIColor whiteColor];
	AlarmStrateyItem *model = data;
	NSMutableArray *high_alarms = model.high_alarms;
	NSMutableArray *low_alarms = model.low_alarms;
	float jibieX = 180;
	float jibieValueX = 220;
	float jibieW = 40;
	float jibieH = 20;
	float jiebieY = 0;
	UIImage *left = [UIImage imageNamed:@"shutter.png"];
	UIImageView* img = [[UIImageView alloc] initWithImage:left];
	img.frame = CGRectMake(ELEMENT_SPACING, 0, ELEMENT_IMG_W_H, ELEMENT_IMG_W_H);
	[rootView1 addSubview:img];
	[self addSubview:rootView1];
	
	Alarm *alarmL1 = low_alarms[0];
	if (alarmL1.enable) {
		UILabel  *lowTip = [[UILabel alloc] init];
		lowTip.frame =CGRectMake(100, 0, 80, 40);
		lowTip.text = @"低电量";
		[rootView1 addSubview:lowTip];
		UILabel  *lowValueTip1 = [[UILabel alloc] init];
		lowValueTip1.frame =CGRectMake(jibieX, jiebieY, jibieW, jibieH);
		lowValueTip1.text = @"1级";
		[rootView1 addSubview:lowValueTip1];
		
		UILabel  *lowValue1 = [[UILabel alloc] init];
		lowValue1.frame =CGRectMake(jibieValueX,jiebieY, jibieW, jibieH);
		NSString *value = [NSString stringWithFormat:@"%f",alarmL1.alarmTriggerVal];
		lowValue1.text = value;
		[rootView1 addSubview:lowValue1];
		jiebieY = jiebieY+jibieH;
	}
	
	Alarm *alarmL2 = low_alarms[1];
	if (alarmL2.enable) {
		UILabel  *lowValueTip2 = [[UILabel alloc] init];
		lowValueTip2.frame =CGRectMake(jibieX, jiebieY, jibieW, jibieH);
		lowValueTip2.text = @"2级";
		[rootView1 addSubview:lowValueTip2];
		
		UILabel  *lowValue2 = [[UILabel alloc] init];
		lowValue2.frame =CGRectMake(jibieValueX, jiebieY, jibieW, jibieH);
		NSString *value = [NSString stringWithFormat:@"%f",alarmL2.alarmTriggerVal];
		lowValue2.text = value;
		[rootView1 addSubview:lowValue2];
		jiebieY = jiebieY+jibieH;
	}
	
	Alarm *alarmL3 = low_alarms[2];
	if (alarmL3.enable) {
		UILabel  *lowValueTip3 = [[UILabel alloc] init];
		lowValueTip3.frame =CGRectMake(jibieX, jiebieY, jibieW, jibieH);
		lowValueTip3.text = @"3级";
		[rootView1 addSubview:lowValueTip3];
		
		UILabel  *lowValue3 = [[UILabel alloc] init];
		lowValue3.frame =CGRectMake(jibieValueX, jiebieY, jibieW, jibieH);
		NSString *value = [NSString stringWithFormat:@"%f",alarmL3.alarmTriggerVal];
		lowValue3.text = value;
		[rootView1 addSubview:lowValue3];
		jiebieY = jiebieY+jibieH;
	}
	
	jiebieY = jiebieY+10;
	
	Alarm *alarmH1 = high_alarms[0];
	if (alarmH1.enable) {
		UILabel  *highTip = [[UILabel alloc] init];
		highTip.frame =CGRectMake(100, jiebieY, 80, 40);
		//lowTip.backgroundColor = [UIColor redColor];
		highTip.text = @"高电量";
		[rootView1 addSubview:highTip];
		
		UILabel  *highValueTip1 = [[UILabel alloc] init];
		highValueTip1.frame =CGRectMake(jibieX, jiebieY, jibieW, jibieH);
		highValueTip1.text = @"1级";
		[rootView1 addSubview:highValueTip1];
		
		UILabel  *highValue1 = [[UILabel alloc] init];
		highValue1.frame =CGRectMake(jibieValueX,jiebieY, jibieW, jibieH);
		NSString *value = [NSString stringWithFormat:@"%f",alarmH1.alarmTriggerVal];
		highValue1.text = value;
		[rootView1 addSubview:highValue1];
		
		jiebieY = jiebieY+jibieH;
	}
	
	Alarm *alarmH2 = high_alarms[1];
	if (alarmH2.enable) {
		UILabel  *highValueTip2 = [[UILabel alloc] init];
		highValueTip2.frame =CGRectMake(jibieX, jiebieY, jibieW, jibieH);
		highValueTip2.text = @"2级";
		[rootView1 addSubview:highValueTip2];
		
		UILabel  *highValue2 = [[UILabel alloc] init];
		highValue2.frame =CGRectMake(jibieValueX, jiebieY, jibieW, jibieH);
		NSString *value = [NSString stringWithFormat:@"%f",alarmH2.alarmTriggerVal];
		highValue2.text = value;
		[rootView1 addSubview:highValue2];
		
		jiebieY = jiebieY+jibieH;
	}
	
	Alarm *alarmH3 = high_alarms[2];
	if (alarmH3.enable) {
		UILabel  *highValueTip3 = [[UILabel alloc] init];
		highValueTip3.frame =CGRectMake(jibieX, jiebieY, jibieW, jibieH);
		highValueTip3.text = @"3级";
		[rootView1 addSubview:highValueTip3];
		
		UILabel  *highValue3 = [[UILabel alloc] init];
		highValue3.frame =CGRectMake(jibieValueX, jiebieY, jibieW, jibieH);
		NSString *value = [NSString stringWithFormat:@"%f",alarmH3.alarmTriggerVal];
		highValue3.text = value;
		[rootView1 addSubview:highValue3];
		jiebieY = jiebieY+jibieH;
	}
	
	
	rootView1.frame = CGRectMake(0, startY, width, jiebieY);
	[self addSubview:rootView1];
	return jiebieY;
}
@end
