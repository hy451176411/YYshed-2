//
//  ModelManager.m
//  所有model的缓存，并带有解析所有model的方法
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import "ModelManager.h"

#define kMaxTag 111

@implementation ModelManager

static  NSMutableDictionary *requestDic;


+ (id)sharedModelManager
{
    static dispatch_once_t pred;
    static ModelManager *modelManager = nil;
    
    dispatch_once(&pred, ^{ modelManager = [[self alloc] init]; });
    return modelManager;
}


/* - (id)init */
//
- (id)init
{
    self = [super init];
    if (self) {
        NSString *urlDic = [[NSBundle mainBundle] pathForResource:@"RequestDictionary" ofType:@"plist"];
        
        requestDic = [[NSMutableDictionary alloc ] initWithContentsOfURL:[NSURL URLWithString:urlDic]];
        
        _isClearCache = YES;
    }
    return self;
}

- (void)setModel:(BaseModel *)model WithTag:(int)tag
{
    switch (tag) {
        case 101:
        {
        }
            break;
        default:
            break;
    }
}




/*
 字典转对象
 */
+ (BaseModel *)parseModelWithDictionary:(NSDictionary *)jsonDic
                                    tag:(int)tag
{
    NSString *messageStr = [jsonDic objectForKey:@"response"];
    
    NSString *urlDic = [[NSBundle mainBundle] pathForResource:@"RequestDictionary" ofType:@"plist"];
    
    requestDic = [[NSMutableDictionary alloc ] initWithContentsOfFile:urlDic];
    
    /*json错误 回调失败 错误码10086*/
    if ([messageStr isKindOfClass:[NSString class]] && [messageStr isEqualToString:@"json错误"]) {
        BaseModel *model = [[[BaseModel alloc] initWithResult:@"json错误" requestTag:10086 andErrorMessage:@{@"json错误":@"text"}] autorelease];
        return model;
    }

    
    BaseModel *tempModel = [[[BaseModel alloc] initWithRequestTag:10086] autorelease];
    /*开始解析model*/
    NSString *tagStr = [NSString stringWithFormat:@"%d",tag];

    if ([requestDic objectForKey:tagStr]) {
       
       id class = NSClassFromString((NSString *)[requestDic objectForKey:tagStr]);
        
        BaseModel *tmpModel = [[(BaseModel *)[class alloc ]initWithDictionary:jsonDic] autorelease];
        [tmpModel setRequestTag:tag];
        
       

        NSLog(@"\nRequestTag:%@\nRequestClass:%@\n",tagStr, [requestDic objectForKey:tagStr]);
        
        return tmpModel;
    }

    return tempModel;
}

+ (BaseModel *)parseModelWithFaileResult:(NSString *)result
                                     tag:(int)tag
{
    BaseModel *tempModel = [[[BaseModel alloc] initWithResult:result requestTag:10086 andErrorMessage:@{@"请求超时":@"data"}]  autorelease];
    if([[ModelManager sharedModelManager] isClearCache])
    {
        [[ModelManager sharedModelManager] setModel:tempModel WithTag:tag];
    }
//    [PublicMethod showMBProgressHUD:@"请求超时" andWhereView:[AppDelegate getNavi].view hiddenTime:kHiddenTime];
    return tempModel;
}


/*
 *
 * 字典转对象 测试版
 *
 */
+ (BaseModel *)parseTestModelWithDictionary:(NSDictionary *)jsonDic
                                        tag:(int)tag
{
    if (jsonDic != nil) {
        return [ModelManager parseModelWithDictionary:jsonDic tag:tag];
    }
    
    NSString *homePath = NSHomeDirectory();
    NSString *documentsPath = [homePath stringByAppendingPathComponent:@"Documents"];
    NSString *tempJsonStr = [NSString stringWithContentsOfFile:[documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.txt",tag]] encoding:NSUTF8StringEncoding error:nil];
    jsonDic = [tempJsonStr JSONValue];
    return [ModelManager parseModelWithDictionary:jsonDic tag:tag];
}

- (void)clearCacheInMemory
{
    for (int i = 0; i < kMaxTag+1; i++) {
        [[ModelManager sharedModelManager] setModel:nil WithTag:i];
    }
}

@end
