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

-(void)getUserInfo:(NSString*)session_token user_Agent:(NSString*)Agent{
	
	NSURL *url=[NSURL URLWithString:@"http://182.92.67.74/api/users/infos"];
	ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
	[request setRequestMethod:@"GET"];
	//访问
	request = [ASIHTTPRequest requestWithURL:url];
	//超时时间多少秒
	[request setTimeOutSeconds:30];
	//访问失败重新访问次数
	[request setNumberOfTimesToRetryOnTimeout:2];
	//是否使用持久化连接
	[request setShouldAttemptPersistentConnection:NO];
	NSString *agent = @"Mozilla/5.0 (Android; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/1.0 Mobile/EC99E CUTV/A312 Safari/525.13";
	NSString *Authorization = [NSString stringWithFormat:@"%@%@",@"bearer ",session_token];
	[request addRequestHeader:@"Authorization" value:Authorization];
	[request addRequestHeader:@"User-Agent" value:agent];
	request.delegate = self;
	[request setTimeOutSeconds:30];
	[self startAsynchronousWithRequest:request];
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
	NSLog(@"请求超时：%@",request.error);
	/*请求超时*/
	if ([_delegate respondsToSelector:@selector(netRequest:Failed:)]) {
		[_delegate netRequest:request.tag Failed:@{@"result":@"0"}];
	}
}

@end
