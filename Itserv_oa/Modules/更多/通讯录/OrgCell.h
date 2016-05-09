//
//  OrgCell.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RADataObject.h"

@interface OrgCell : UITableViewCell
{
    IBOutlet UIImageView *_imgViewIcon;
    IBOutlet UILabel *_labelName;
    IBOutlet UIImageView *_imgViewJiantou;
}

- (void)loadType:(int)type dataObject:(RADataObject *)data;

@end
