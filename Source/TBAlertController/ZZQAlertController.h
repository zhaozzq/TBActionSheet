//
//  ZZQAlertController.h
//
//  Created by 杨萧玉 on 15/10/29.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZZQAlertActionStyle) {
    ZZQAlertActionStyleDefault = 0,
    ZZQAlertActionStyleCancel,
    ZZQAlertActionStyleDestructive
};

typedef NS_ENUM(NSInteger, ZZQAlertControllerStyle) {
    ZZQAlertControllerStyleActionSheet = 0,
    ZZQAlertControllerStyleAlert
};

@interface ZZQAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) ZZQAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nullable,nonatomic,strong,readonly) void (^handler)(ZZQAlertAction * _Nonnull);

+ (id)actionWithTitle:(nullable NSString *)title style:(ZZQAlertActionStyle)style handler:(void (^ __nullable)( ZZQAlertAction *action))handler;

@end

@interface ZZQAlertController : UIViewController



@property (nonatomic,strong,readonly) id adaptiveAlert;
@property (nullable,nonatomic,weak) UIViewController *ownerController;
@property (nullable,nonatomic,strong) UIColor *tintColor;
@property(nonatomic,assign) UIAlertViewStyle alertViewStyle;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(ZZQAlertControllerStyle)preferredStyle;
- (void)addAction:(ZZQAlertAction *)action;

@property (nonatomic, readonly) NSArray<ZZQAlertAction *> *actions;
@property (nullable, nonatomic, copy, readonly) NSArray< void (^)(UITextField *_Nonnull textField)> *textFieldHandlers;

@property (nonatomic, strong, nullable) ZZQAlertAction *preferredAction NS_AVAILABLE_IOS(9_0);

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField * _Nonnull textField))configurationHandler;

@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

@property (nonatomic, readonly) ZZQAlertControllerStyle preferredStyle;

@end

NS_ASSUME_NONNULL_END
