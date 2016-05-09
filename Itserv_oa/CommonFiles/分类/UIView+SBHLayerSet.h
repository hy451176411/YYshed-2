//
//  UIView+SBHLayerSet.h
//  Emtpy
//
//  Created by SBH on 14-7-30.
//  Copyright (c) 2014年 SBH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SBHLayerSet)

//设置layer的边框线大小，颜色
- (void)layerWithBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color;

//设置边框为1固定颜色  默认实线边框和颜色
- (void)layerBorderWidthColorDefault;

//虚线边框  默认颜色
- (void)layerBorderDashedWidthColorDefault;

//设置虚线边框宽度，颜色
- (void)layerWithBorderDashedWidth:(CGFloat)width
                   withBorderColor:(UIColor *)color
                          lineDash:(NSArray *)lineDash;

//设置layer的圆角
- (void)layerWithRadius:(CGFloat)radius;

//设置layer成为圆形
- (void)layerRound;

//设置边框阴影
- (void)layerWithShadowOffset:(CGSize)offset withColor:(UIColor *)color;

@end
