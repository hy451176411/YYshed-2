//
//  AlarmStratey.m
//  Itserv_oa
//
//  Created by mac on 16/5/19.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "AlarmStratey.h"

@implementation AlarmStratey
-(void)initAlarmStratey:(NSDictionary*)model{
	self.strategyitems = [NSMutableArray array];
	if ([model objectForKey:@"strategy_id"]) {
		self.strategy_id =[model objectForKey:@"strategy_id"];
	}
	if ([model objectForKey:@"strategy_name"]) {
		self.strategy_name =[model objectForKey:@"strategy_name"];
	}
	AlarmStrateyItem *item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:charge_config withName:@"charge_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:air_temperature_config withName:@"air_temperature_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:air_humidity_config withName:@"air_humidity_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:co_ppm_config withName:@"co_ppm_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:co2_ppm_config withName:@"co2_ppm_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:lux_config withName:@"lux_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:soil_temperature_config withName:@"soil_temperature_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:soil_humidity_config withName:@"soil_humidity_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:soil_moisture_config withName:@"soil_moisture_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:rain_config withName:@"rain_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:windvelocity_config withName:@"windvelocity_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:pm2_5_ppm_config withName:@"pm2_5_ppm_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:smoke_ppm_config withName:@"smoke_ppm_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:pm10_ppm_config withName:@"pm10_ppm_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
	
	item = [AlarmStrateyItem initSelf];
	item = [item tryFillWithType:model withAlarmStrategy:item withType:pm10_ppm_config withName:@"pm10_ppm_config"];
	if (item) {
		[self.strategyitems addObject:item];
	}
}
@end
