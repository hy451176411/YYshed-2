//
//  SendtoView.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "SendtoView.h"

@implementation SendtoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _labelSendName = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, frame.size.width, 15)];
        _labelSendName.font = SystemFontOfSize(14);
        [self addSubview:_labelSendName];
        
        
//        _labelSendEmail = [[UILabel alloc] initWithFrame:CGRectMake(0, _labelSendName.top + _labelSendName.height, _labelSendName.width, _labelSendName.height)];
//        _labelSendEmail.font = _labelSendName.font;
//        _labelSendEmail.textColor = GrayColor;
//        [self addSubview:_labelSendEmail];
        
    }
    return self;
}

- (void)loadData:(NSDictionary *)dic
{
    _labelSendName.text = dic[@"name"];
//    _labelSendEmail.text = dic[@"mail"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
