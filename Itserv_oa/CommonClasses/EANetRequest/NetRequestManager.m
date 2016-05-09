//
//  NetRequestManager.m
//  创建正式版网络请求对象和本地测试模仿版接口请求对象
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import "NetRequestManager.h"

@implementation NetRequestManager
//创建正式请求对象，使用的时候retain
+ (YYNetRequest *)createNetRequestWithDelegate:(id <YYNetRequestDelegate>)delegate
{
    return [[[YYNetRequest alloc] initWithDelegate:delegate] autorelease];
}
//创建测试请求对象，使用的时候retain
+ (YYNetRequest *)createTestNetRequestWithDelegate:(id<YYNetRequestDelegate>)delegate
{
    return [[[TestNetRequest alloc] initWithDelegate:delegate] autorelease];
}

@end
