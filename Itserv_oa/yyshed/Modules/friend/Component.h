//
//  Friend.h
//  FriendsList
//
//  Created by hellovoidworld on 14/12/12.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Component : NSObject

/** air_temperature */
@property(nonatomic, copy) NSString *air_temperature;

/** air_humidity */
@property(nonatomic, copy) NSString *air_humidity;

/** sn */
@property(nonatomic, copy) NSString *sn;

- (instancetype) initWithDictionary:(NSDictionary *) dictionary;
+ (instancetype) friendWithDictionary:(NSDictionary *) dictionary;

@end
