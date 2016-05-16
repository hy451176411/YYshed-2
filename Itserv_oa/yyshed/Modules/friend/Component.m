//
//  Friend.m
//  FriendsList
//
//  Created by hellovoidworld on 14/12/12.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "Component.h"

@implementation Component

- (instancetype) initWithDictionary:(NSDictionary *) dictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

+ (instancetype) friendWithDictionary:(NSDictionary *) dictionary {
    return [[self alloc] initWithDictionary:dictionary];
}

@end
