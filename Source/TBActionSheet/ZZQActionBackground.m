//
//  ZZQActionBackground.m
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/1/31.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import "ZZQActionBackground.h"

@implementation ZZQActionBackground

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.superview respondsToSelector:@selector(close)]) {
        [self.superview performSelector:@selector(close)];
    }
}

@end
