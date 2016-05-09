//
//  NetRequest.h
//  正式版网络请求类
//
//  Created by houpeng on 13-7-4.
//  Copyright (c) 2013年 eastedge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIFormDataRequest.h"

#import "BaseModel.h"


#import "EADefine.h"

@class NetRequest;


@protocol NetRequestDelegate <NSObject>

@optional
/*
*不管请求成功失败，都走下面的请求完成回调
*/
- (void)netRequest:(int)tag Finished:(NSDictionary *)model;
- (void)netRequest:(int)tag Failed:(NSDictionary *)model;
- (void)netRequest:(int)tag requestFailed:(NSString *)message;

@end

@interface NetRequest : NSObject <ASIHTTPRequestDelegate>

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

//////////////////////////在下面写请求方法/////////////////////////////////
//登录接口
- (void)netRequestLoginUser:(NSString *)user password:(NSString *)pwd;

- (void)netRequestLoginUser:(NSString *)user password:(NSString *)pwd verifycode:(NSString *)strCode;

- (void)netRequestRegistUsername:(NSString *)username
                           phone:(NSString *)phone
                          bureau:(NSString *)bureau
                            dept:(NSString *)dept;

//登录后在发送这个请求才完成真正的登录 http://localhost:8088/names.nsf?login&username=xxx&password=xxx
- (void)netRequestSureLoginUser:(NSString *)user password:(NSString *)pwd tag:(NSInteger)tag;
-(void)login:(NSString*) username password:(NSString*) psd;
-(void)login1:(NSString*) username password:(NSString*) psd;
//获取文件内容
- (void)netRequestFile:(NSString *)url;

//下载文件
- (void)netRequestDownFile:(NSString *)url
              withFileName:(NSString *)fileName;

//获取子菜单列表getSubMenuList
- (void)netRequestgetSubMenuListMenuid:(NSString *)menuid;

//获取待处理列表getNeedDealList  从0开始  分页
- (void)netRequestNeedDealListStar:(int)start dotype:(int)dotype size:(int)size;


//获取推送消息列表getNotifyMsgList  从0开始  分页
- (void)netRequestNotifyMsgListStart:(int)start size:(int)size;

//获取公文列表getDocList
- (void)netRequestNeedDealListStar:(int)start
                          moduleid:(NSString *)moduleid
                              size:(int)size
                              type:(NSString *)type;

//获取公文列表getDocList  综合查询
- (void)netRequestNeedDealListStar:(int)start
                          moduleid:(NSString *)moduleid
                              size:(int)size
                           keyword:(NSString *)keyword
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endTime;

//获取邮件列表getMailList
- (void)netRequestMailListStart:(int)start type:(int)type;

//删除邮件deleteMail
- (void)netRequestDeleteMailID:(NSString *)mailId;

//发送发送邮件sendMail
- (void)netRequestSendMailFrom:(NSString *)from
                        sendto:(NSString *)sendto
                        copyto:(NSString*)copyto
                       blindto:(NSString *)blindto
                         title:(NSString *)title
                       content:(NSString *)content
                   attachments:(id)attachments;

//邮件内容
- (void)netRequestEmailContetn:(NSString *)emailID;

- (void)netRequestEmailContactListDept:(NSString *)strDept;

- (void)netRequestPeopleSearch:(NSString *)strSearch;

//获取通讯录getContactList
- (void)netRequestContactListStart:(int)start;

//获取版本
- (void)netRequestVersion;
//获取服务器机构
- (void)netRequestAgency;

- (void)netRequestCodeUsername:(NSString *)username
                        bureau:(NSString *)bureau
                      password:(NSString *)pass;

- (void)netRequestNewSendMailFrom:(NSString *)from
                           sendto:(NSString *)sendto
                           copyto:(NSString*)copyto
                          blindto:(NSString *)blindto
                            title:(NSString *)title
                          content:(NSString *)content
                      attachments:(id)attachments;
@end
