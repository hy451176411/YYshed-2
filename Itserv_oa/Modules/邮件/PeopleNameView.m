//
//  PeopleNameView.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-10.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "PeopleNameView.h"

@implementation PeopleNameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _imgViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_imgViewBg];
        
        _labelName = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, frame.size.width, frame.size.height)];
        _labelName.backgroundColor = [UIColor clearColor];
        _labelName.font = [UIFont systemFontOfSize:12];
        _labelName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelName];
    }
    return self;
}

- (CGFloat)loadDataView:(NSDictionary *)dic
{
    NSString *strName = dic[@"personname"];
    CGSize size = [strName sizeWithStringFont:_labelName.font sizewidth:ScreenWidth sizeheight:MAXFLOAT];
    
    //iPhone width  200
    
    UIImage *img = [UIImage imageNamed:@"btn_contactblock"];
    
    if (size.width >= 200) {
        self.width = 210;
    } else {
        self.width = size.width + 10;
    }
    
    _imgViewBg.image = [img stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    _imgViewBg.width = self.width;
    
    _labelName.text = strName;
    _labelName.width = size.width;
    return 0;
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
