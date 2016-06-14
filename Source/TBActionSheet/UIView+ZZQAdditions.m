//
//  UIView+TBAdditions.m
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/2/16.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import "UIView+ZZQAdditions.h"
#import <objc/runtime.h>

#pragma mark - UIView (ZZQActionSheet)



@implementation UIView (ZZQActionSheet)

- (void)interruptGesture
{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if (([gesture isKindOfClass:[UITapGestureRecognizer class]] || [gesture isKindOfClass:[UIPanGestureRecognizer class]]) && gesture.enabled == YES) {
            gesture.enabled = NO;
            gesture.enabled = YES;
        }
    }
    for (UIView *subview in self.subviews) {
        [subview interruptGesture];
    }
}

@end


@implementation UIView (ZZQRectCorner)

@dynamic zzqRectCorner;

- (ZZQRectCorner)zzqRectCorner
{
    NSNumber *corner = objc_getAssociatedObject(self, @selector(zzqRectCorner));
    return corner.integerValue;
}

- (void)setZzqRectCorner:(ZZQRectCorner)zzqRectCorner
{
    objc_setAssociatedObject(self, @selector(zzqRectCorner), @(zzqRectCorner), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTopCornerRadius:(CGFloat) radius
{
    if (radius < 0) {
        return;
    }
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setBottomCornerRadius:(CGFloat) radius
{
    if (radius < 0) {
        return;
    }
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setAllCornerRadius:(CGFloat) radius
{
    if (radius < 0) {
        return;
    }
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setNoneCorner
{
    self.layer.mask = nil;
}

- (void)setCornerRadius:(CGFloat) radius
{
    switch (self.zzqRectCorner) {
        case ZZQRectCornerTop: {
            [self setTopCornerRadius:radius];
            break;
        }
        case ZZQRectCornerBottom: {
            [self setBottomCornerRadius:radius];
            break;
        }
        case ZZQRectCornerNone: {
            [self setNoneCorner];
            break;
        }
        case ZZQRectCornerAll: {
            [self setAllCornerRadius:radius];
            break;
        }
        default: {
            break;
        }
    }
}

@end