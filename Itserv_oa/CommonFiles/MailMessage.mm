//
//  MailMessage.m
//  Itserv_oa
//
//  Created by admin on 15/2/7.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import "MailMessage.h"
#import "RADataObject.h"
#import "PicFileView.h"

@implementation MailMessage

//实现单例
SYNTHESIZE_SINGLETONE_FOR_CLASS(MailMessage);


- (id)init
{
    self = [super init];
    if (self) {
        
        self.strPopAddress = @"pop.163.com";
        self.strSmtpAddress = @"smtp.163.com";

        self.popPort = 110;
        self.smtpPort = 25;
        
        NSString *strEmail = [UserDefaults objectForKey:kEmail];
        NSString *strMailPass = [UserDefaults objectForKey:kMailPass];
        
        self.strEmail = strEmail;
        self.strPass = strMailPass;
        
        _muArrMessage = [[NSMutableArray alloc] init];
        
        if (strEmail.length == 0 || strMailPass.length == 0) {//没有绑定
            _isMailLogin = NO;
        } else {//已绑定过
//            [self verifyEmail:strEmail mailPass:strMailPass withIsSuccess:nil];
        }
    }
    return self;
}

#pragma mark 验证用户
- (void)verifyEmail:(NSString *)email
           mailPass:(NSString *)mailPass
      withIsSuccess:(void(^)(BOOL success))isSuccess
{
    self.strEmail = email;
    self.strPass = mailPass;
    
//    [self.popSession cancelAllOperations];
    self.popSession = [[MCOPOPSession alloc] init];
    
    _popSession.hostname = _strPopAddress;
    _popSession.port = _popPort;
    _popSession.username = _strEmail;
    _popSession.password = _strPass;
    //    if (oauth2Token != nil) {
    //        self.imapSession.OAuth2Token = oauth2Token;
    //        imapSession.authType = MCOAuthTypeSASLLogin;
    //    }
    //    _popSession.authType = MCOAuthTypeSASLLogin;
    
    _popSession.connectionType = MCOConnectionTypeClear;
    _popSession.connectionLogger = ^(void * connectionID, MCOConnectionLogType type, NSData * data) {
        //        @synchronized(weakSelf) {
        //            if (type != MCOConnectionLogTypeSentPrivate) {
        //                //                NSLog(@"event logged:%p %i withData: %@", connectionID, type, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //            }
        //        }
    };
    
    // Reset the inbox
    NSLog(@"checking account");
    
    __block MailMessage *message = self;
    MCOPOPOperation *popCheckOp = [_popSession checkAccountOperation];
    [popCheckOp start:^(NSError *error) {
        NSLog(@"finished checking account.");
        if (error == nil) {//邮箱绑定成功
            message.isMailLogin = YES;
            if (isSuccess) {
                isSuccess(YES);
            }
        } else {
            if (isSuccess) {
                isSuccess(NO);
            }
            NSLog(@"error loading account: %@", error);
        }
    }];


    
 }

#pragma mark 注销邮箱
- (void)logoutEmailWithIsSuccess:(void(^)(BOOL success))isSuccess
{
        __block MailMessage *message = self;
    MCOPOPOperation * op = [_popSession disconnectOperation];
    [op start:^(NSError * error) {
        NSLog(@"error:%@",error);
        if (error) {
            if (isSuccess) {
                isSuccess(NO);
            }
        } else {
            if (isSuccess) {
                isSuccess(YES);
            }
            message.isMailLogin = NO;
        }
    }];
}


#pragma mark 获取邮件列表
- (void)arrEmailMessage:(void(^)(NSArray *arrMessage))arrMessage
{
    num = 0;
    times = 0;
    [_muArrMessage removeAllObjects];
    
    
    MCOPOPOperation * op = [_popSession disconnectOperation];
    [op start:^(NSError * error) {
        NSLog(@"error:%@",error);
        if (error) {
            
        } else {
            [self verifyEmail:self.strEmail mailPass:self.strPass withIsSuccess:^(BOOL success){
                if (success) {
                    MCOPOPFetchMessagesOperation *messagesOpertaion = [_popSession fetchMessagesOperation];
                    [messagesOpertaion start:^(NSError *error, NSArray *message){
                        num = message.count;
                        for (int i = message.count - 1 ; i >= 0; i--) {
                            MCOPOPMessageInfo *popMsg = message[i];
                            MCOPOPFetchMessageOperation * messageOp = [_popSession fetchMessageOperationWithIndex:popMsg.index];
                            [messageOp start:^(NSError * error, NSData * messageData) {
                                // messageData is the RFC 822 formatted message data.
                                ++times;
                                MCOMessageParser * parser = [[MCOMessageParser alloc] initWithData:messageData];
                                [_muArrMessage addObject:parser];
                                if (times == num) {
                                    NSLog(@"成功");
                                    arrMessage(_muArrMessage);
                                }
                            }];
                        }
                        //            NSLog(@"%@",message);
                    }];
                } else {
                    arrMessage(_muArrMessage);
                }
            }];
        }
    }];

    
  
}

- (void)deleteEmailIndex:(int)index withIsSuccess:(void(^)(BOOL success,int row))isSuccess
{
    
    MCOIndexSet * indexes = [MCOIndexSet indexSet];
    [indexes addIndex:index];
    MCOPOPOperation * op = [_popSession deleteMessagesOperationWithIndexes:indexes];
    [op start:^(NSError * error) {
//        NSLog(@"%@",error);
        if (error) {
            
        } else {
            isSuccess(YES,index);
        }
    }];
}

- (NSString *)contentWithStr:(NSString *)strText arr:(NSArray *)arrAtte
{
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:[strText componentsSeparatedByString:@"-"]];
    NSRange range;
    range.location = muArr.count - arrAtte.count;
    range.length = arrAtte.count;
    [muArr removeObjectsInRange:range];
    strText = [muArr componentsJoinedByString:@"-"];
    __autoreleasing NSString *strContent = [[NSString alloc] initWithString:strText];
    return strContent;
}


#pragma mark 发送
- (void)sendEmailToArr:(NSArray *)toArr
                 ccArr:(NSArray *)ccArr
                bccArr:(NSArray *)bccArr
               subject:(NSString *)subject
           contentText:(NSString *)content
         attachmentArr:(NSArray *)attachmentArr
              mailType:(MailType)type
         withIsSuccess:(void(^)(BOOL success))isSuccess
{
    MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
    MCOMessageHeader * header = [builder header];
    
    NSString *email = [NSString stringWithFormat:@"%@@gdciq.gov.cn",_strEmail];
    if ([_strEmail rangeOfString:@"@gdciq.gov.cn"].location != NSNotFound) {
        email = _strEmail;
    }
    //发件人
    [header setFrom:[MCOAddress addressWithDisplayName:_strEmail mailbox:email]];
    //收件人
    NSMutableArray *muArrTo = [NSMutableArray array];
    for (int i = 0; i < toArr.count; i++) {
        RADataObject *data = toArr[i];
        NSDictionary *dic = data.dicOrgparent;
        NSString *mail = dic[@"mail"];
        [muArrTo addObject:[MCOAddress addressWithMailbox:mail]];
    }
    [header setTo:muArrTo];
    //抄送
    if (ccArr.count > 0) {
        NSMutableArray  *muArrCC = [NSMutableArray array];
        for (int i = 0; i < ccArr.count; i++) {
            RADataObject *data = ccArr[i];
            NSDictionary *dic = data.dicOrgparent;
            NSString *mail = dic[@"mail"];
            [muArrCC addObject:[MCOAddress addressWithMailbox:mail]];
        }
        [header setCc:muArrCC];
    }
    //密送
    if (ccArr.count > 0) {
        NSMutableArray  *muArrBcc = [NSMutableArray array];
        for (int i = 0; i < bccArr.count; i++) {
            RADataObject *data = bccArr[i];
            NSDictionary *dic = data.dicOrgparent;
            NSString *mail = dic[@"mail"];
            [muArrBcc addObject:[MCOAddress addressWithMailbox:mail]];
        }
        [header setBcc:muArrBcc];
    }
    
    [[builder header] setSubject:subject];
    [builder setTextBody:content];
    
    //附件
    if (type == ForwardingMail) {//可能有附件
        for (int i = 0; i < attachmentArr.count; i++) {
            PicFileView *picFileView = attachmentArr[i];
            NSString *imgName = picFileView.strImgName;
            UIImage *img = picFileView.img;
            NSData *data = nil;
            if (!img) {
                data = picFileView.data;
            } else {
                data = UIImagePNGRepresentation(img);
            }
            BOOL isLine = picFileView.isLine;
            MCOAttachment *attachment = [MCOAttachment attachmentWithData:data filename:imgName];
//            [attachment setInlineAttachment:isLine];
            
            [builder addAttachment:attachment];
        }
    } else if (type == SendMail) {//发送邮件也有附件
        for (int i = 0; i < attachmentArr.count; i++) {
            PicFileView *picFileView = attachmentArr[i];
            UIImage *img = picFileView.img;
            NSString *imgName = picFileView.strImgName;
            NSData *data = UIImagePNGRepresentation(img);
            MCOAttachment *attachment = [MCOAttachment attachmentWithData:data filename:imgName];
            [builder addAttachment:attachment];
        }
    }

    NSData * rfc822Data = [builder data];
    MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
    smtpSession.hostname = _strSmtpAddress;
    smtpSession.port = _smtpPort;
    smtpSession.username = _strEmail;
    smtpSession.password = _strPass;
    smtpSession.connectionType = MCOConnectionTypeClear;
    MCOSMTPOperation * op = [smtpSession sendOperationWithData:rfc822Data];
    [op start:^(NSError * error) {
        NSLog(@"error:%@",error);
        if (error) {
            isSuccess(NO);
        } else {
            isSuccess(YES);
        }
    }];
}

@end