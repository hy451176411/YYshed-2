//
//  EmailCell.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-4.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailCell : UITableViewCell
{
    __weak IBOutlet UIImageView *_imgViewIcon;
    IBOutlet UILabel *_labelTitle;
    IBOutlet UILabel *_labelPeople;
    IBOutlet UILabel *_labelTime;
}

- (void)loadData:(NSDictionary *)dic type:(int)type;

//pop3
- (void)loadMailCore:(MCOMessageParser *)messageParser type:(int)type;
- (void)loadSendMail:(NSDictionary *)dic;
@end
