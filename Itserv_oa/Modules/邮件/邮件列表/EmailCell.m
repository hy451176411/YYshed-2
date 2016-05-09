//
//  EmailCell.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-4.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "EmailCell.h"
#import "SBHPublicDate.h"
#import "RADataObject.h"

@implementation EmailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)loadData:(NSDictionary *)dic type:(int)type
{
    _labelTitle.text = dic[@"title"];
    _labelTime.text = dic[@"recevietime"];
    _labelPeople.text = (type == 1 || type == 2) ? dic[@"sendto"] : dic[@"from"];
    
    NSString *strReadName = @"read";
    BOOL isNew = [dic[@"isnew"] boolValue];
    if (isNew) {//未读邮件
        strReadName = @"noRead";
//        _labelTitle.font = BoldSystemFontOfSize(17);
    } else {
//        _labelTitle.font = SystemFontOfSize(17);        
    }
    _imgViewIcon.image = ImageWithImgName(strReadName);
}


- (void)loadMailCore:(MCOMessageParser *)messageParser type:(int)type
{
    _labelTitle.text = messageParser.header.subject;
    _labelTime.text = [SBHPublicDate stringFromDate:messageParser.header.date timeType:@"yyyy-MM-dd"];
    MCOAddress * address = nil;
    if (type == 1 || type == 2) {
        address = messageParser.header.sender;
    } else {
        address = messageParser.header.from;
    }
    _labelPeople.text = address.displayName;
}

//发件箱加载数据
- (void)loadSendMail:(NSDictionary *)dic
{
    _labelPeople.text = [UserDefaults objectForKey:kEmail];
    _labelTitle.text = dic[@"subject"];
    _labelTime.text = [SBHPublicDate stringFromDate:dic[@"time"] timeType:@"yyyy-MM-dd"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
