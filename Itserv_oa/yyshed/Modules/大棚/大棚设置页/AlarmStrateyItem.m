//
//  Test.m
//  Itserv_oa
//
//  Created by mac on 16/5/19.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "AlarmStrateyItem.h"

@implementation AlarmStrateyItem
+(id)initSelf{
	AlarmStrateyItem *item = [[AlarmStrateyItem alloc]init];
		//item.type = default_config;
		item.low_alarms = [NSMutableArray array];
		item.high_alarms = [NSMutableArray array];
		for (int i=0; i<3; i++) {
			Alarm *alarm = [[Alarm alloc] init];
			alarm.enable = NO;
			Alarm *alarmH = [[Alarm alloc] init];
			alarmH.enable = NO;
			[item.low_alarms addObject:alarm];
			[item.high_alarms addObject:alarmH];
		}
	return item;
}
-(AlarmStrateyItem*)JSON2Item:(NSDictionary*)dict withAlarmStrategy:(AlarmStrateyItem*)item{
	for (int i=0; i<3; i++) {
		NSString *enablekey = [NSString stringWithFormat:@"enable_l_%d",(i+1)];
		if ([dict objectForKey:enablekey]) {
			Boolean b = NO;
			b = [[dict objectForKey:enablekey] boolValue];
			Alarm *alarm= item.low_alarms[i];
			alarm.enable = b;
			item.low_alarms[i] = alarm;
			//Alarm *alarm1 = item.low_alarms[i];
		}

		NSString *enableHkey = [NSString stringWithFormat:@"enable_h_%d",(i+1)];
		if ([dict objectForKey:enableHkey]) {
			Boolean b = NO;
			b = [[dict objectForKey:enableHkey] boolValue];
			Alarm *alarm= item.high_alarms[i];
			alarm.enable = b;
			item.high_alarms[i] = alarm;
			//Alarm *alarm1 = item.high_alarms[i];
		}

		NSString *lowValueKey = [NSString stringWithFormat:@"l_value_%d",(i+1)];
		if ([dict objectForKey:lowValueKey]) {
			float f = 0.0;
			f= [[dict objectForKey:lowValueKey] floatValue];
			Alarm *alarm= item.low_alarms[i];
			alarm.alarmTriggerVal = f;
			item.low_alarms[i] = alarm;
			//Alarm *alarm1 = item.low_alarms[i];
		}

		NSString *highValueKey = [NSString stringWithFormat:@"h_value_%d",(i+1)];
		if ([dict objectForKey:highValueKey]) {
			float f = 0.0;
			f= [[dict objectForKey:highValueKey] floatValue];
			Alarm *alarm= item.high_alarms[i];
			alarm.alarmTriggerVal = f;
			item.high_alarms[i] = alarm;
			//Alarm *alarm1 = item.high_alarms[i];
		}


	}
	return item;
}

-(AlarmStrateyItem*)tryFillWithType:(NSDictionary*)obj withAlarmStrategy:(AlarmStrateyItem *)item withType:(AlarmType)type withName:(NSString *)name{
	item.type = type;
	NSDictionary *dic;
	if ([obj objectForKey:name]) {
	   dic = [obj objectForKey:name];
	}
	if (dic) {
		item = [self JSON2Item:dic withAlarmStrategy:item];
	}

	return item;
}
@end
