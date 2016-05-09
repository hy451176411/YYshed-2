//
//  PushMessageCell.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-30.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "PushMessageCell.h"

@implementation PushMessageCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadData:(NSDictionary *)dic
{
    _labelTitle.text = dic[@"title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
