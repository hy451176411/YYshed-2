//
//  UIView+SBHLayerSet.m
//  Emtpy
//
//  Created by SBH on 14-7-30.
//  Copyright (c) 2014年 SBH. All rights reserved.
//

#import "UIView+SBHLayerSet.h"

@implementation UIView (SBHLayerSet)

#pragma mark 设置layer的边框线大小，颜色
- (void)layerWithBorderWidth:(CGFloat)width withBorderColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

#pragma mark 设置边框为1固定颜色  默认边框和颜色
- (void)layerBorderWidthColorDefault
{
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1;
}

#pragma mark 默认虚线边框  颜色  4:2循环
- (void)layerBorderDashedWidthColorDefault
{
    [self layerAddDashedWidth:1 withColor:[UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1] lineDashPattern:@[@4, @2]];
}

#pragma mark 设置虚线边框宽度，颜色
- (void)layerWithBorderDashedWidth:(CGFloat)width
                   withBorderColor:(UIColor *)color
                          lineDash:(NSArray *)lineDash
{
    [self layerAddDashedWidth:width withColor:color lineDashPattern:lineDash];
}

- (void)layerAddDashedWidth:(CGFloat)width
                  withColor:(UIColor *)color
            lineDashPattern:(NSArray *)lineDash
{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.lineDashPattern = lineDash;
    border.lineWidth = width;
    [self.layer addSublayer:border];
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
}

#pragma mark 设置layer的圆角
- (void)layerWithRadius:(CGFloat)radius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

#pragma mark 设置layer成为圆形
- (void)layerRound
{
    CGFloat radius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
}

#pragma mark 设置边框阴影
- (void)layerWithShadowOffset:(CGSize)offset withColor:(UIColor *)color
{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = YES;
}


@end
