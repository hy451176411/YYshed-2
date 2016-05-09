//
//  MattersCell.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-2.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "MattersCell.h"

@implementation MattersCell

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
    CGFloat height = 20;
    
    NSString *strTitle = dic[@"title"];
    CGSize size = [strTitle sizeWithStringFontSize:17 sizewidth:255 sizeheight:MAXFLOAT];
    if (size.height > 45) {
        size.height = 45;
    }
    height += (size.height + 15);

    return height;
}

#pragma mark 加载数据
- (void)loadData:(NSDictionary *)dic
{
    NSString *strDes = dic[@"modulename"];
    NSString *strName = dic[@"sender"];
    _labelHeard.text = [NSString stringWithFormat:@"【%@】%@",strDes,strName];
    _labelTitle.text = dic[@"title"];
    
    CGSize size = [_labelTitle.text sizeWithStringFont:_labelTitle.font sizewidth:_labelTitle.width sizeheight:MAXFLOAT];
    if (size.height > 45) {
        size.height = 45;
    }
    _labelTitle.height = size.height;
    
    _labelTime.text = dic[@"recevietime"];
    
    _labelHeard.top = _labelTitle.top + _labelTitle.height;
    _labelTime.top = _labelHeard.top;
    
    NSString *strRankName = @"defineNotUrgentIcon";
    BOOL isRank = [dic[@"rank"] boolValue];
    if (isRank) {//是急件
        strRankName = @"defineUrgentIcon";
//        _labelTitle.textColor = RedColor;
    } else {
//        _labelTitle.textColor = BlackColor;
    }
    _imgViewIcon.image = ImageWithImgName(strRankName);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
