//
//  UITableViewCell+LoadXib.h
//  HunBaSha
//
//  Created by xiexianhui on 14-5-8.
//  Copyright (c) 2014年 HapN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LoadXib)

//加载nib文件  默认是第1个视图
+ (id)loadFromXibWithOwner:(id)owner;

//加载nib文件 可以传options参数
+ (id)loadFromXibWithOwner:(id)owner options:(NSDictionary *)options;

//加载nib文件   选择加载位置的视图
+ (id)loadFromXibWithOwner:(id)owner index:(NSInteger)index options:(NSDictionary *)options;


@end
