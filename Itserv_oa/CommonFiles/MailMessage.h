//
//  MailMessage.h
//  Itserv_oa
//
//  Created by admin on 15/2/7.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>

#define kEmail @"email"
#define kMailPass @"mailPass"


@interface MailMessage : NSObject
{
	
	int num;
	int times;
	NSMutableArray *_muArrMessage;
}
@property (strong, nonatomic) MCOPOPSession *popSession;
//pop 和 smtp 地址
@property (strong, nonatomic) NSString *strPopAddress;
@property (assign, nonatomic) unsigned int popPort;
@property (strong, nonatomic) NSString *strSmtpAddress;
@property (assign, nonatomic) unsigned int smtpPort;

//邮箱 和 密码
@property (strong, nonatomic) NSString *strEmail;
@property (strong, nonatomic) NSString *strPass;

@property (assign, nonatomic) BOOL isMailLogin;


//单例
DECLARE_SINGLETON(MailMessage);

- (NSString *)contentWithStr:(NSString *)strText arr:(NSArray *)arrAtte;

//注销邮箱
- (void)logoutEmailWithIsSuccess:(void(^)(BOOL success))isSuccess;

//验证用户
- (void)verifyEmail:(NSString *)email
		   mailPass:(NSString *)mailPass
	  withIsSuccess:(void(^)(BOOL success))isSuccess;

- (void)arrEmailMessage:(void(^)(NSArray *arrMessage))arrMessage;

- (void)deleteEmailIndex:(int)index withIsSuccess:(void(^)(BOOL success,int row))isSuccess;

// 发送
- (void)sendEmailToArr:(NSArray *)toArr
				 ccArr:(NSArray *)ccArr
				bccArr:(NSArray *)bccArr
			   subject:(NSString *)subject
		   contentText:(NSString *)content
		 attachmentArr:(NSArray *)attachmentArr
			  mailType:(MailType)type
		 withIsSuccess:(void(^)(BOOL success))isSuccess;
@end
