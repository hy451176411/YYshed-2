//
//  ContactsCell.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-4.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "ContactsCell.h"

@implementation ContactsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadDic:(NSDictionary *)dic
{
    _labelName.text = dic[@"personname"];
    _labelPhone.text = dic[@"phoneno"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
