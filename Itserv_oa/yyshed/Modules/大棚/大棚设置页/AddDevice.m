//
//  Peopleview.m
//  Itserv_oa
//
//  Created by mac on 16/5/20.
//  Copyright (c) 2016年 xiexianhui. All rights reserved.
//

#import "AddDevice.h"
//#define DEFAULT_VOID_COLOR
@implementation AddDevice

- (void)drawRect:(CGRect)rect{
	UIColor *bg = [self StringToUIColor:@"#F2F2E2"];
	 [self.backgroud setBackgroundColor:bg];
	self.theRequest = [NetRequestManager createNetRequestWithDelegate:self];
}

/*十六进制转uicolor*/
-(UIColor*)StringToUIColor:(NSString*)stringToConvert{
	UIColor *DEFAULT_VOID_COLOR =[UIColor whiteColor];
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	if ([cString length] < 6)
		return DEFAULT_VOID_COLOR;
	if ([cString hasPrefix:@"#"])
		cString = [cString substringFromIndex:1];
	if ([cString length] != 6)
		return DEFAULT_VOID_COLOR;
	
	NSRange range;
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
						   green:((float) g / 255.0f)
							blue:((float) b / 255.0f)
						   alpha:1.0f];
}

- (IBAction)btnClick:(id)sender {
	[self removeFromSuperview];
}
- (IBAction)addDevice:(id)sender {
	NSString *devUuid = self.devUuid.text;
	NSString *alias = self.alias.text;
	if ([devUuid isEqualToString:@""]||[alias isEqualToString:@""]) {
		[SBPublicAlert showMBProgressHUD:@"请输入有效参数" andWhereView:self hiddenTime:kHiddenAlertTime];
	}else{
		[self.theRequest addDevice:devUuid withAlias:alias];
	}
	
}
-(void)passValue:(NSString*)value{
	self.devUuid.text = value;
	
}

- (IBAction)zxing:(id)sender {
	if (self.delegate && [self.delegate respondsToSelector:@selector(ScanZcode:)]) {
		[_delegate ScanZcode:nil];
	}
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self.devUuid resignFirstResponder];
	[self.alias resignFirstResponder];
}
#pragma mark 登录请求成功
- (void)netRequest:(int)tag Finished:(NSDictionary *)model
{
	NSLog(@"----------%@",model);
	//[self initDataSource:model];
	NSString *status = [NSString stringWithFormat:@"status = %@",[model objectForKey:@"status"]];
	[SBPublicAlert showMBProgressHUD:status andWhereView:self hiddenTime:kHiddenAlertTime];
	//[self removeFromSuperview];
}

- (void)netRequest:(int)tag Failed:(NSDictionary *)model
{
	NSLog(@"请求超时");
	[SBPublicAlert showMBProgressHUD:@"请求超时" andWhereView:self hiddenTime:kHiddenAlertTime];
}

- (void)netRequest:(int)tag requestFailed:(NSString *)message
{
	[SBPublicAlert showMBProgressHUD:message andWhereView:self hiddenTime:kHiddenAlertTime];
}
@end
