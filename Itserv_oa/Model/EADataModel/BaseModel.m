//
//  BaseModel.m
//  基类model，可以根据需要修改扩充
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)dealloc
{
    [_errorMessage release], _errorMessage = nil;
    [_Result release]; _Result = nil;
    [super dealloc];
}


/* - (id)initWith: */
//
- (id)initWithRequestTag:(NSInteger)aRequestTag
{
    self = [super init];
    if (self) {
        _requestTag = aRequestTag;
    }
    return self;
}



/* - (id)initWith: */
//
- (id)initWithResult:(NSString*)aResult requestTag:(NSInteger)aRequestTag andErrorMessage:(NSDictionary *)error
{
    self = [super init];
    if (self) {
        _requestTag = aRequestTag;
        self.Result = aResult;
//         self.success = YES;
        if ([error isKindOfClass:[NSDictionary class]]) {
            _errorMessage = [[error objectForKey:@"data" ] retain];
            NSInteger errorcode = [[error objectForKey:@"errorcode"] integerValue];
            if (errorcode == 0) {
                self.success = YES;
            } else {
                self.success = NO;
            }
        }
    }
    return self;
}


/*
- (BOOL)success
{
    if (![_response isEqualToString:@"error"]) {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSString *)errorMessage
{
    if ([_Result isEqualToString:@"0"]) {
        return @"请求失败 errorcode = 0";
    }
    else if ([_Result isEqualToString:@"1"])
    {
        return @"";
    }
    else if([_Result isEqualToString:@"2"])
    {
        return @"没有数据 errorcode = 2";
    }
    else if ([_Result isEqualToString:@"100"])
    {
        return @"请求超时 errorcode = 100";
    }
    else if ([_Result isEqualToString:@"101"])
    {
        return @"json错误 errorcode = 101";
    }
    else{
        return [NSString stringWithFormat:@"未知错误 errorcode = %@",_Result];
    }
}
*/
/*  Keyed Archiving */
//
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.Result forKey:@"text"];

    [encoder encodeObject:self.errorMessage forKey:@"error"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.Result = [decoder decodeObjectForKey:@"text"];

        self.errorMessage = [decoder decodeObjectForKey:@"error"];
    }
    return self;
}



@end
