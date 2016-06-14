//
//  ConditionerView.h
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/4/3.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZQActionSheet;
@interface ConditionerView : UIView
@property (weak,nonatomic) ZZQActionSheet *actionSheet;
- (void)setUpUI;
@end
