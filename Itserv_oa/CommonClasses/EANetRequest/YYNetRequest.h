//
//  YYNetRequest.h
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

#import "BaseModel.h"


#import "EADefine.h"

@class NetRequest;


@protocol YYNetRequestDelegate <NSObject>

@optional
/*
 *不管请求成功失败，都走下面的请求完成回调
 */
- (void)netRequest:(int)tag Finished:(NSDictionary *)model;
- (void)netRequest:(int)tag Failed:(NSDictionary *)model;
- (void)netRequest:(int)tag requestFailed:(NSString *)message;

@end
@interface YYNetRequest : NSObject<ASIHTTPRequestDelegate>

@property (retain, nonatomic) NSMutableDictionary *requestDic;

@property (nonatomic, assign) id <NetRequestDelegate>delegate;


@property (nonatomic,retain) NSString *screct;
@property (nonatomic, retain) NSString *oauth_token;
@property (nonatomic, retain) NSString *oauth_verifier;

- (void)startAsynchronousWithRequest:(ASIHTTPRequest *)request;
/*
 *
 *setDelegate when init
 *
 */
- (id)initWithDelegate:(id <NetRequestDelegate>)aDelegate;

-(void)login:(NSString*) username password:(NSString*) psd;
@end
