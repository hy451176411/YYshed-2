//
//  NetRequestManager.h
//  创建正式版网络请求对象和本地测试模仿版接口请求对象
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYNetRequest.h"

#import "TestNetRequest.h"

@interface NetRequestManager : NSObject

+ (YYNetRequest *)createNetRequestWithDelegate:(id <YYNetRequestDelegate>)delegate;

+ (YYNetRequest *)createTestNetRequestWithDelegate:(id<YYNetRequestDelegate>)delegate;

@end
