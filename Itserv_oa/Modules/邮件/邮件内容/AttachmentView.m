//
//  AttachmentView.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-7.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "AttachmentView.h"

@implementation AttachmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imgViewTopLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
        imgViewTopLine.backgroundColor = GrayColor;
        [self addSubview:imgViewTopLine];
        
        _labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, frame.size.width - 4, 20)];
        _labelName.backgroundColor = ClearColor;
        [self addSubview:_labelName];
        
        _labelSize = [[UILabel alloc] initWithFrame:CGRectMake(_labelName.left, _labelName.top + _labelName.height, _labelName.width, 15)];
        _labelSize.font = SystemFontOfSize(12);
        _labelSize.backgroundColor = ClearColor;
        [self addSubview:_labelSize];
        
        UIImageView *imgViewBottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 38, frame.size.width, 1)];
        imgViewBottomLine.backgroundColor = GrayColor;
        [self addSubview:imgViewBottomLine];
    }
    return self;
}

- (void)loadData:(NSDictionary *)dic
{
    CGFloat size = [dic[@"size"] floatValue] / 1024;
    _labelName.text = dic[@"name"];
    _labelSize.text = [NSString stringWithFormat:@"%.2fkb",size];
}

- (void)loadMCOAttachment:(MCOAttachment *)attachment
{
 //   NSLog(@"%@",attachment.filename);
    _labelName.text = attachment.filename;
    //    _labelSize.text  = attachment
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(attachmentView:)]) {
        [_delegate attachmentView:self];
    }
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
