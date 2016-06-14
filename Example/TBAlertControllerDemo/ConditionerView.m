//
//  ConditionerView.m
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 16/4/3.
//  Copyright © 2016年 杨萧玉. All rights reserved.
//

#import "ConditionerView.h"
#import "ZZQActionSheet.h"
#import "ZZQActionContainer.h"

@interface ConditionerView ()
@property (weak, nonatomic) IBOutlet UISlider *buttonHeightSlider;
@property (weak, nonatomic) IBOutlet UISlider *buttonWidthSlider;
@property (weak, nonatomic) IBOutlet UISlider *offsetYSlider;
@property (weak, nonatomic) IBOutlet UISwitch *enableBackgroundTransparentSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *enableBlurEffectSwitch;
@property (weak, nonatomic) IBOutlet UISlider *rectCornerRadiusSlider;
@property (weak, nonatomic) IBOutlet UISlider *animationDurationSlider;
@property (weak, nonatomic) IBOutlet UISlider *animationDumpingRatioSlider;
@property (weak, nonatomic) IBOutlet UISlider *animationVelocitySlider;
@property (weak, nonatomic) IBOutlet UISlider *ambientColorSlider;
@end

@implementation ConditionerView

- (IBAction)buttonHeight:(UISlider *)sender {
    self.actionSheet.buttonHeight = sender.value;
    [ZZQActionSheet appearance].buttonHeight = sender.value;
}

- (IBAction)buttonWidth:(UISlider *)sender {
    self.actionSheet.sheetWidth = sender.value * [UIScreen mainScreen].bounds.size.width;
    [ZZQActionSheet appearance].sheetWidth = sender.value * [UIScreen mainScreen].bounds.size.width;
}


- (IBAction)offsetY:(UISlider *)sender {
    self.actionSheet.offsetY = -sender.value;
    [ZZQActionSheet appearance].offsetY = -sender.value;
}


- (IBAction)backgroundTransparentEnabled:(UISwitch *)sender {
    self.actionSheet.backgroundTransparentEnabled = sender.isOn;
    [ZZQActionSheet appearance].backgroundTransparentEnabled = sender.isOn;
    [self refreshActionSheet];
}


- (IBAction)blurEffectEnabled:(UISwitch *)sender {
    self.actionSheet.blurEffectEnabled = sender.isOn;
    [ZZQActionSheet appearance].blurEffectEnabled = sender.isOn;
    [self refreshActionSheet];
}


- (IBAction)cornerRadius:(UISlider *)sender {
    self.actionSheet.rectCornerRadius = sender.value;
    [ZZQActionSheet appearance].rectCornerRadius = sender.value;
}


- (IBAction)animationDuration:(UISlider *)sender {
    self.actionSheet.animationDuration = sender.value;
    [ZZQActionSheet appearance].animationDuration = sender.value;
}

- (IBAction)animationDampingRatio:(UISlider *)sender {
    self.actionSheet.animationDampingRatio = sender.value;
    [ZZQActionSheet appearance].animationDampingRatio = sender.value;
}

- (IBAction)animationVelocity:(UISlider *)sender {
    self.actionSheet.animationVelocity = sender.value;
    [ZZQActionSheet appearance].animationVelocity = sender.value;
}

- (IBAction)ambientColor:(UISlider *)sender {
    self.actionSheet.ambientColor = [UIColor colorWithHue:sender.value saturation:sender.value brightness:1 alpha:0.5];
    [ZZQActionSheet appearance].ambientColor = self.actionSheet.ambientColor;
}

- (IBAction)touchUp:(id)sender {
    [self refreshActionSheet];
}

- (void)setUpUI
{
    self.buttonHeightSlider.value = self.actionSheet.buttonHeight;
    self.buttonWidthSlider.value = self.actionSheet.sheetWidth / [UIScreen mainScreen].bounds.size.width;
    self.offsetYSlider.value = self.actionSheet.offsetY;
    self.enableBackgroundTransparentSwitch.on = self.actionSheet.isBackgroundTransparentEnabled;
    self.enableBlurEffectSwitch.on = self.actionSheet.isBlurEffectEnabled;
    self.rectCornerRadiusSlider.value = self.actionSheet.rectCornerRadius;
    self.animationDurationSlider.value = self.actionSheet.animationDuration;
    self.animationDumpingRatioSlider.value = self.actionSheet.animationDampingRatio;
    self.animationVelocitySlider.value = self.actionSheet.animationVelocity;
    self.ambientColorSlider.value = 0;
}

- (void)refreshActionSheet
{
    self.bounds = CGRectMake(0, 0, self.actionSheet.sheetWidth, self.bounds.size.height);
    [[self.actionSheet valueForKeyPath:@"actionContainer"] removeFromSuperview];
    ZZQActionContainer *container = [[ZZQActionContainer alloc] initWithSheet:self.actionSheet];
    [self.actionSheet setValue:container forKeyPath:@"actionContainer"];
    [self.actionSheet addSubview:container];
    [self.actionSheet setUpLayout];
    [self.actionSheet setUpContainerFrame];
    [self.actionSheet setUpStyle];
}
@end
