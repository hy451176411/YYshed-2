//
//  Test.h
//  Itserv_oa
//
//  Created by mac on 16/5/19.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"
typedef enum  {
	charge_config,
	air_temperature_config,
	air_humidity_config,
	co_ppm_config,
	co2_ppm_config,
	lux_config,
	soil_temperature_config,
	soil_humidity_config,
	soil_moisture_config,
	rain_config,
	windvelocity_config,
	pm2_5_ppm_config,
	smoke_ppm_config,
	pm10_ppm_config,
	default_config
} AlarmType;
//
typedef enum  {
	High, Low
} HighLowAlarm;

@interface AlarmStrateyItem : NSObject
+(id)initSelf;
@property  AlarmType type;
@property (nonatomic, retain) NSMutableArray *high_alarms;
@property (nonatomic, retain) NSMutableArray *low_alarms;
-(AlarmStrateyItem*)JSON2Item:(NSDictionary*)dict  withAlarmStrategy:(AlarmStrateyItem *)model;
-(AlarmStrateyItem*)tryFillWithType:(NSDictionary*)obj withAlarmStrategy:(AlarmStrateyItem *)item withType:(AlarmType)type withName:(NSString *)name;
@end
