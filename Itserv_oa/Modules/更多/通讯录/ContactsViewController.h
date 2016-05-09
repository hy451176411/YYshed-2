//
//  ContactsViewController.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonInSection.h"
@class RADataObject;

@protocol ContactsViewDelegate <NSObject>

@optional
- (void)contactsWithPeople:(NSArray *)arr withType:(NSInteger)type;

@end

@interface ContactsViewController : BaseViewController<UITextFieldDelegate,ButtonInSeactionDelegate>

@property (nonatomic, assign) id<ContactsViewDelegate> delegate;
@property (nonatomic, assign) NSInteger type;//没有tool  1收件人  2抄送  3密送


- (void)reloadData;

@end
