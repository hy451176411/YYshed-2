//
//  TestNetRequest.m
//  育婴师
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 zan. All rights reserved.
//

#import "TestNetRequest.h"


#import "ModelManager.h"

@implementation TestNetRequest

/*
 重写的其父类NetRequst的下面的方法
 */
- (void)startAsynchronousWithRequest:(ASIHTTPRequest *)request
{
    BaseModel *model = [ModelManager parseTestModelWithDictionary:nil tag:request.tag];
    if ([self.delegate respondsToSelector:@selector(netRequest:Finished:)]) {
        [self.delegate netRequest:request.tag Finished:@{}];
    }
}

@end
