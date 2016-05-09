//
//  EmailContactsViewController.h
//  Itserv_oa
//
//  Created by admin on 15/3/12.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsViewDelegate <NSObject>

@optional
- (void)contactsWithPeople:(NSArray *)arr withType:(NSInteger)type;

@end

@interface EmailContactsViewController : BaseViewController
@property (nonatomic, assign) id<ContactsViewDelegate> delegate;

@property (nonatomic, assign) NSInteger type;//没有tool  1收件人  2抄送  3密送

@end
