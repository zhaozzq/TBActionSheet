//
//  ZZQActionSheetController.m
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/2/15.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import "ZZQActionSheetController.h"
#import "ZZQActionSheet.h"
#import "UIWindow+ZZQAdditions.h"
#import "TBMacro.h"

@implementation ZZQActionSheetController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.actionSheet];
    self.actionSheet.frame = self.view.bounds;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.actionSheet.frame = self.view.bounds;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIWindow *window = self.actionSheet.previousKeyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows firstObject];
    }
    return [[window tb_viewControllerForStatusBarStyle] preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden
{
    UIWindow *window = self.actionSheet.previousKeyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows firstObject];
    }
    return [[window tb_viewControllerForStatusBarHidden] prefersStatusBarHidden];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (self.actionSheet.blurEffectEnabled && !kiOS8Later) {
        [self.actionSheet setUpStyle];
    }
}
@end
