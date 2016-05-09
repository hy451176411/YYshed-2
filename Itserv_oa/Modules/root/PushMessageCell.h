//
//  PushMessageCell.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushMessageCell : UITableViewCell
{
    IBOutlet UIImageView *_imgViewIcon;//图标
    IBOutlet UILabel *_labelTitle;//标题
    IBOutlet UILabel *_labelTime;//时间
}

- (void)loadData:(NSDictionary *)dic;

@end
