//
//  ZZQActionButton.h
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/1/31.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZZQActionButtonStyle) {
    ZZQActionButtonStyleDefault = 0,
    ZZQActionButtonStyleCancel,
    ZZQActionButtonStyleDestructive
};

@interface ZZQActionButton : UIButton
@property (nonatomic,nullable) UIColor *normalColor;
@property (nonatomic,nullable) UIColor *highlightedColor;
@property (nonatomic) ZZQActionButtonStyle style;
@property (nonatomic,nullable,strong,readonly) void (^handler)(ZZQActionButton * button);

@property (weak,nonatomic) UIView *behindColorView;

+ (instancetype)buttonWithTitle:(NSString *)title style:(ZZQActionButtonStyle)style;
+ (instancetype)buttonWithTitle:(NSString *)title style:(ZZQActionButtonStyle)style handler:(void (^ __nullable)( ZZQActionButton * button))handler;
@end

NS_ASSUME_NONNULL_END

