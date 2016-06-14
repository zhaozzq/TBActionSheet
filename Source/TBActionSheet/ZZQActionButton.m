//
//  ZZQActionButton.m
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/1/31.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import "ZZQActionButton.h"
#import "TBMacro.h"

/**
 *  可定制风格和圆角的按钮
 */
@interface ZZQActionButton()

@property (nonatomic,nullable,strong,readwrite) void (^handler)(ZZQActionButton * _Nonnull button);

@end

@implementation ZZQActionButton

+ (instancetype)buttonWithTitle:(NSString *)title style:(ZZQActionButtonStyle)style
{
    return [ZZQActionButton buttonWithTitle:title style:style handler:nil];
}

+ (instancetype)buttonWithTitle:(NSString *)title style:(ZZQActionButtonStyle)style handler:(void (^ __nullable)( ZZQActionButton * _Nonnull button))handler
{
    ZZQActionButton *button = [ZZQActionButton buttonWithType:UIButtonTypeCustom];
    button.style = style;
    button.handler = handler;
    button.clipsToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:20]];
    return button;
}

- (void)dealloc
{

}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        if (self.highlightedColor) {
            self.backgroundColor = self.highlightedColor;
        }
        else {
            self.behindColorView.alpha = 0.5;
        }
    }
    else {
        if (self.normalColor) {
            self.backgroundColor = self.normalColor;
        }
        else {
            self.behindColorView.alpha = 1;
        }
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.backgroundColor = normalColor;
    if (!self.highlightedColor) {
        self.highlightedColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
}

@end
