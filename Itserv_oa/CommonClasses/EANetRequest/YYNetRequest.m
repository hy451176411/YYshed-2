//
//  YYNetRequest.m
//  Itserv_oa
//
//  Created by mac on 16/5/9.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "YYNetRequest.h"
#import "ModelManager.h"

#include <CommonCrypto/CommonDigest.h>

#include <CommonCrypto/CommonHMAC.h>
#import "PicFileView.h"
#import "NSString+Extension.h"

@implementation YYNetRequest
- (void)dealloc
{
	for (ASIHTTPRequest *request in _requestDic.allValues) {
		[request clearDelegatesAndCancel];
		request.delegate = nil;
	}
}


/* - (id)init */
//
- (id)init
{
	self = [super init];
	if (self) {
		_requestDic = [[NSMutableDictionary alloc] init];
	}
	return self;
}

/* - (id)initWith: */
//
- (id)initWithDelegate:(id <NetRequestDelegate>)aDelegate
{
	self = [super init];
	if (self) {
		
		_requestDic = [[NSMutableDictionary alloc] init];
		_delegate = aDelegate;
	}
	return self;
}

- (void)setRequest:(ASIHTTPRequest *)request forKey:(int)tag
{
	NSString *tagKey = [NSString stringWithFormat:@"%d",tag];
	ASIHTTPRequest *tempRequest = [_requestDic objectForKey:tagKey];
	[tempRequest clearDelegatesAndCancel];
	[_requestDic setObject:request forKey:tagKey];
}

-(void)login:(NSString*) username password:(NSString*) psd{
	username = [NSString stringWithFormat:@"%@",@"shixuepeng"];
	psd =[NSString stringWithFormat:@"%@",@"shixuepeng"];
	NSMutableDictionary *resultsDictionary;// 返回的 JSON 数据
	NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:username, @"username",psd,@"password",nil];
	if ([NSJSONSerialization isValidJSONObject:userDictionary])
	{
		NSError *error;
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
		NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
		NSURL *url = [NSURL URLWithString:@"http://182.92.67.74/api/sessions"];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		[request setRequestMethod:@"POST"];
		request.tag = Login;
		request.delegate = self;
		[request setPostBody:tempJsonData];
		[self startAsynchronousWithRequest:request];
		NSError *error1 = [request error];
		if (!error1) {
			NSString *response = [request responseString];
			NSLog(@"Test：%@",response);
		}
	}
	
 
}

- (void)startAsynchronousWithRequest:(ASIHTTPRequest *)request
{
	[request startAsynchronous];
}


#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseStr = [request responseString];
	//NSLog(@"responseStr\n++++++++++++++++\n%@\n++++++++++++++++\n%d-----%d", responseStr ,request.responseStatusCode,request.tag);
	NSDictionary *dic = [responseStr JSONValue];

	if (!dic) {
		responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\n"];
		dic = [responseStr JSONValue];
	}
	/*请求成功*/
	if ([_delegate respondsToSelector:@selector(netRequest:Finished:)]) {
		[_delegate netRequest:request.tag Finished:dic];
	}
	
	
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
	BaseModel *model = [ModelManager parseModelWithFaileResult:@"100" tag:request.tag];
	NSLog(@"请求超时：%@",request.error);
	/*请求超时*/
	if ([_delegate respondsToSelector:@selector(netRequest:Failed:)]) {
		[_delegate netRequest:request.tag Failed:@{@"result":@"0"}];
	}
}

@end
