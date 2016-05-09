//
//  FileMessageCell.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-5-31.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "FileMessageCell.h"

@implementation FileMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadData:(NSDictionary *)theDic withIndex:(NSInteger)row
{
    NSString *strImg = [NSString stringWithFormat:@"OfficialIcon%d",row+1];
    _imgViewIcon.image = ImageWithPath(PathForPNGResource(strImg));
    
    _labelTitle.text = theDic[@"title"];
//    _labelMess.text = theDic[@"des"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
