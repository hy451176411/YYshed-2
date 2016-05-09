//
//  UITableViewCell+LoadXib.m
//  HunBaSha
//
//  Created by xiexianhui on 14-5-8.
//  Copyright (c) 2014年 HapN. All rights reserved.
//

#import "UIView+LoadXib.h"

@implementation UIView (LoadXib)

#pragma mark 加载nib文件
+ (id)loadFromXibWithOwner:(id)owner
{
    return [self loadFromXibWithOwner:owner index:0 options:nil];
}


#pragma mark 加载nib文件 可以传options参数
+ (id)loadFromXibWithOwner:(id)owner options:(NSDictionary *)options
{
    return [self loadFromXibWithOwner:owner index:0 options:options];
}

#pragma mark 加载nib文件   选择加载位置的视图
+ (id)loadFromXibWithOwner:(id)owner index:(NSInteger)index options:(NSDictionary *)options
{
    NSString *nibName = NSStringFromClass(self.class);
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:options];
    
    NSInteger count = [arr count];
    if (arr && count && count > index) {
        return arr[index];
    }else {
        return nil;
    }

}


@end
