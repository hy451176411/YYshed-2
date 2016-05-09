//
//  PeopleMessageView.h
//  Itserv_oa
//
//  Created by admin on 15/3/24.
//  Copyright (c) 2015年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RADataObject.h"
@interface PeopleMessageView : UIView
{
    __weak IBOutlet UIView *_viewBg;
    
    __weak IBOutlet UILabel *_labelMail;
    __weak IBOutlet UILabel *_labelPhone;
    __weak IBOutlet UILabel *_labelTitle;
    
    __weak IBOutlet UIButton *_btnPhone;
    __weak IBOutlet UIButton *_btnMessage;
    __weak IBOutlet UIButton *_btnEmail;
    
}
@property (nonatomic, strong) NSDictionary *dicPeople;

- (void)loadDataRADataObject:(RADataObject *)raDataObj;

@end
