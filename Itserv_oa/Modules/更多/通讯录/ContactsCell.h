//
//  ContactsCell.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-4.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsCell : UITableViewCell
{
    IBOutlet UILabel *_labelName;
    IBOutlet UILabel *_labelPhone;
}
- (void)loadDic:(NSDictionary *)dic;

@end
