//
//  SendEmailViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-5.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendEmailViewDelegate <NSObject>

@optional
- (void)sendEmailSuccess;

@end

@interface SendEmailViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, assign) MailType type;//
@property (nonatomic, assign) id<SendEmailViewDelegate> delegate;
@property (nonatomic, retain) NSDictionary *dicDraft;
@property (nonatomic, retain) NSDictionary *dicPeople;

- (void)loadReplyForwardingDic:(NSDictionary *)dic;
- (void)loadDic:(NSDictionary *)dic;

- (void)loadDraftDetail:(NSDictionary *)dic;
@end
