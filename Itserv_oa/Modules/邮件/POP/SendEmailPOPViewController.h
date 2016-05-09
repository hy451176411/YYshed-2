//
//  SendEmailPOPViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-5.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MailCore/MailCore.h>

@protocol SendEmailPOPViewDelegate <NSObject>

@optional
- (void)sendEmailSuccess;
- (void)sendDraftEmailSuccessIndex:(NSInteger)index;
- (void)saveDraftEmail;
@end

@interface SendEmailPOPViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) MailType type;//
@property (nonatomic, assign) id<SendEmailPOPViewDelegate> delegate;
@property (nonatomic, retain) NSDictionary *dicDraft;//草稿
@property (nonatomic, assign) NSInteger index;

@property (strong, nonatomic) MCOMessageParser *msgParser;

- (void)loadReplyForwardingDic:(MCOMessageParser *)messageParser;
- (void)loadDic:(MCOMessageParser *)parser;

- (void)loadDraftDetail:(NSDictionary *)dic;
@end
