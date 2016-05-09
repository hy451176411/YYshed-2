//
//  ProcessFileCell.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-2.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "ProcessFileCell.h"

@implementation ProcessFileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
    [GlobalData loadViewBorder:_viewCellBg];
    [GlobalData loadView:_viewCellBg withRadius:3];
}


+ (CGFloat)cellHeight:(NSDictionary *)dic
{
    CGFloat height = 10;
    
    NSString *strTitle = dic[@"title"];
    CGSize size = [strTitle sizeWithStringFontSize:17 sizewidth:250 sizeheight:MAXFLOAT];
    if (size.height > 45) {
        size.height = 45;
    }
    
    height += (size.height + 15);
    
    return height;
}

- (void)loadData:(NSDictionary *)dic
{
//    NSString *strName = dic[@"modulename"];
//    _labelHeardText.text = [NSString stringWithFormat:@"【%@】请您查看",strName];
    _labelTitle.text = dic[@"title"];
    
    CGSize size = [_labelTitle.text sizeWithStringFont:_labelTitle.font sizewidth:_labelTitle.width sizeheight:MAXFLOAT];
    if (size.height > 45) {
        size.height = 45;
    }
    _labelTitle.height = size.height;
    
    _labelTime.top = _labelTitle.top + _labelTitle.height;

    _labelTime.text = dic[@"time"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
