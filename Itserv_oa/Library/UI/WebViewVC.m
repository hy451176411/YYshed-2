//
//  WebViewVC.m
//  Itserv_oa
//
//  Created by mac on 16/5/27.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "WebViewVC.h"

@interface WebViewVC ()

@end

@implementation WebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.VCTitlte.text = self.titleStr;
	NSData* data = [self.content dataUsingEncoding:NSUTF8StringEncoding];
	[self.webview loadData:data MIMEType:@"text/html" textEncodingName:@"UTF8" baseURL:nil];
}


//左边按键点击动作，返回处理
- (IBAction)back:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
