//
//  PicFileView.m
//  Itserv_oa
//
//  Created by xiexianhui on 14-7-1.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import "PicFileView.h"

@implementation PicFileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width - 15;
        
        _imgViewPic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, width, width)];
        [self addSubview:_imgViewPic];
//        _imgViewPic.backgroundColor = RedColor;
        [_imgViewPic setContentMode:UIViewContentModeScaleAspectFill];
        _imgViewPic.clipsToBounds = YES;
        
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame = CGRectMake(self.width - 25, 0, 25, 25);
        [btnDelete setImage:ImageWithPath(PathForPNGResource(@"btn_voice_cancel")) forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(btnDeletePicClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDelete];
        
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:245 green:245 blue:250 alpha:1].CGColor;

//        self.backgroundColor = GreenColor;
        // Initialization code
    }
    return self;
}

- (void)loadWithImg:(UIImage *)theImg withFileName:(NSString *)strFile
{
    _imgViewPic.image = theImg;

    self.img = theImg;
    self.strImgName = strFile;
    //获取后缀名
    NSArray *arr = [strFile componentsSeparatedByString:@"."];
    self.strImgType = [arr lastObject];
}

#pragma mark UIButton按钮事件
- (void)btnDeletePicClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(picFileView:)]) {
        [_delegate picFileView:self];
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
