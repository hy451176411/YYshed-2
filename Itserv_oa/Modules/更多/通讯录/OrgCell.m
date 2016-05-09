//
//  OrgCell.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "OrgCell.h"

@implementation OrgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadType:(int)type dataObject:(RADataObject *)data
{
    if (type == 1) {//一级部门
        _imgViewIcon.left = 15;
    } else {//二级部门
        _imgViewIcon.left = 40;
    }
    _labelName.left = _imgViewIcon.left + _imgViewIcon.width + 5;
    _labelName.text = data.dicOrgparent[@"orgname"];
    
    if (data.isOpen) {
        _imgViewJiantou.transform = CGAffineTransformMakeRotation(M_PI/2);
    } else {
        _imgViewJiantou.transform = CGAffineTransformMakeRotation(0);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
