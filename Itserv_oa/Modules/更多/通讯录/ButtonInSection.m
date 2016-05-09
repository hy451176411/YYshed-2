//
//  ButtonInSection.m
//  ChiHao
//
//  Created by user on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ButtonInSection.h"

@implementation ButtonInSection
@synthesize delegate,section,sectionLable,sectionButton,opened,arr,dataDic;

-(id)initWithFrame:(CGRect)frame title:(NSDictionary *)dic section:(NSInteger )sectionnumber opened:(BOOL)isopened delegate:(id<ButtonInSeactionDelegate>)aDelegate
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleAction:)];
        [self addGestureRecognizer:tapGesture];
        self.userInteractionEnabled = YES;
        [tapGesture release];
        section  = sectionnumber;
        delegate = aDelegate;
        opened = isopened;
        
        CGFloat originX = 70;
        CGRect titleLabelFrame = CGRectMake(originX, frame.origin.y, frame.size.width - originX - 10, frame.size.height);
        
        
        UIImageView *imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 34, 34)];
        imgViewIcon.image = ImageWithPath(PathForPNGResource(@"item_ico_contacts"));
        [self addSubview:imgViewIcon];
        [imgViewIcon release];
        
        sectionLable = [[UILabel alloc]initWithFrame:titleLabelFrame];
        sectionLable.backgroundColor = [UIColor clearColor];
        sectionLable.text = [dic objectForKey:@"orgname"];
        [sectionLable setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        sectionLable.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:sectionLable];
        
        sectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sectionButton.frame = CGRectMake(ScreenWidth-50, (44-27/2)/2, 15, 15);
        sectionButton.userInteractionEnabled = NO;
        sectionButton.selected = isopened;
        [self addSubview:sectionButton];
        
        _imgViewJian = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 30, (50- 13)/2, 9, 13)];
        _imgViewJian.image = [UIImage imageNamed:@"jiantou.png"];
        [self addSubview:_imgViewJian];
        
        BOOL status = [dic[@"opened"] boolValue];
        if (status) {
            _imgViewJian.transform = CGAffineTransformMakeRotation(M_PI/2);
        } else {
        
        }
        
        UIImageView *grayLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50-2, ScreenWidth - 20, 1)];
        grayLine.image = [UIImage imageNamed:@"line"];
        [self addSubview:grayLine];
        [grayLine release];
        
        self.backgroundColor = RGBFromColor(0xc8c8c8);

    }
    return self;
}

-(IBAction)toggleAction:(id)sender
{
    sectionButton.selected = !sectionButton.selected;
    
    if (sectionButton.selected) {
        opened = YES;
        _imgViewJian.transform = CGAffineTransformMakeRotation(M_PI/2);
        if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
            [delegate sectionHeaderView:self sectionOpened:section];
        }
    }else {
        opened = NO;
        _imgViewJian.transform = CGAffineTransformMakeRotation(0);

        if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
            [delegate sectionHeaderView:self sectionClosed:section];
        }
    }
}

-(void)dealloc{
    [arr release];
	[sectionLable release];
	[super dealloc];
}
@end
