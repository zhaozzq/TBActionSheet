//
//  UIView+TBAdditions.h
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/2/16.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZZQActionSheet)
- (void)interruptGesture;
@end

#pragma mark - UIView (RectCorner)

/**
 *  加圆角
 */

typedef NS_OPTIONS(NSUInteger, ZZQRectCorner) {
    ZZQRectCornerTop = 1 << 0,
    ZZQRectCornerBottom = 1 << 1,
    ZZQRectCornerNone = 0,
    ZZQRectCornerAll = ZZQRectCornerTop|ZZQRectCornerBottom,
};

@interface UIView (ZZQRectCorner)
@property (nonatomic,assign) ZZQRectCorner zzqRectCorner;
- (void)setCornerRadius:(CGFloat) radius;
@end