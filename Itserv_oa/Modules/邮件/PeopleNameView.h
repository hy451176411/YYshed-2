//
//  PeopleNameView.h
//  Itserv_oa
//
//  Created by xiexianhui on 14-6-10.
//  Copyright (c) 2014年 xiexianhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleNameView : UIView
{
    UIImageView *_imgViewBg;//
    UILabel *_labelName;//人名
}

- (CGFloat)loadDataView:(NSDictionary *)dic;

@end
