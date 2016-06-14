//
//  ZZQAlertController.m
//
//  Created by 杨萧玉 on 15/10/29.
//  Copyright © 2015年 Tencent. All rights reserved.
//

#import "ZZQAlertController.h"
#import "TBMacro.h"
#import <objc/runtime.h>

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@interface UIViewController (ZZQAlertController)
@property (nonatomic,strong,nullable) ZZQAlertController *zzqAlertController;
@end

@implementation UIViewController (ZZQAlertController)

@dynamic zzqAlertController;

#pragma mark - AssociatedObject

- (ZZQAlertController *)zzqAlertController
{
    return objc_getAssociatedObject(self, @selector(zzqAlertController));
}

- (void)setZzqAlertController:(ZZQAlertController *)zzqAlertController
{
    objc_setAssociatedObject(self, @selector(zzqAlertController), zzqAlertController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(tb_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(aClass,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(aClass,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)tb_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([viewControllerToPresent isKindOfClass:[ZZQAlertController class]]) {
        ZZQAlertController* controller = (ZZQAlertController *)viewControllerToPresent;
        if (kiOS8Later) {
            ((UIAlertController *)controller.adaptiveAlert).view.tintColor = controller.tintColor;
            [self tb_presentViewController:((ZZQAlertController *)viewControllerToPresent).adaptiveAlert animated:flag completion:completion];
        }
        else {
            if ([controller.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
                self.zzqAlertController = controller;
                controller.ownerController = self;
                [controller.textFieldHandlers enumerateObjectsUsingBlock:^(void (^configurationHandler)(UITextField *textField), NSUInteger idx, BOOL *stop) {
                    configurationHandler([controller.adaptiveAlert textFieldAtIndex:idx]);
                }];
                [controller.adaptiveAlert show];
            }
            else if ([controller.adaptiveAlert isKindOfClass:[UIActionSheet class]]) {
                self.zzqAlertController = controller;
                controller.ownerController = self;
                [controller.adaptiveAlert showInView:self.view];
            }
        }
    }
    else {
        [self tb_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

@end

@interface ZZQAlertAction ()
@property (nullable, nonatomic, readwrite) NSString *title;
@property (nonatomic,readwrite) ZZQAlertActionStyle style;
@property (nullable,nonatomic,strong,readwrite) void (^handler)(ZZQAlertAction *);
@end

@implementation ZZQAlertAction
+ (id)actionWithTitle:(NSString *)title style:(ZZQAlertActionStyle)style handler:(void (^)(ZZQAlertAction *))handler
{
    if (kiOS8Later) {
        UIAlertActionStyle actionStyle = (NSInteger)style;
        return [UIAlertAction actionWithTitle:title style:actionStyle handler:(void (^ __nullable)(UIAlertAction *))handler];
    }
    else {
        ZZQAlertAction *action = [[ZZQAlertAction alloc] init];
        action.title = [title copy];
        action.style = style;
        action.handler = handler;
        action.enabled = YES;
        return action;
    }
}

@end

@interface ZZQAlertController() <UIActionSheetDelegate, UIAlertViewDelegate>
@property (nonnull,nonatomic,strong,readwrite) id adaptiveAlert;

@property (nonnull,nonatomic, readwrite) NSMutableArray<ZZQAlertAction *> *mutableActions;
@property (nonnull,nonatomic, readwrite) NSArray<ZZQAlertAction *> *actions;

@property (nullable, nonatomic, copy, readwrite) NSArray< void (^)(UITextField *textField)> *textFieldHandlers;

@property (nonatomic, readwrite) ZZQAlertControllerStyle preferredStyle;
@end

@implementation ZZQAlertController

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (kiOS8Later) {
            _adaptiveAlert = [[UIAlertController alloc] init];
        }
        else {
            _adaptiveAlert = [[UIActionSheet alloc] init];
            _mutableActions = [NSMutableArray array];
            _textFieldHandlers = @[];
            _preferredStyle = ZZQAlertControllerStyleActionSheet;
            ((UIActionSheet *)_adaptiveAlert).delegate = self;
        }
        [self addObserver:self forKeyPath:@"view.tintColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"view.tintColor"];
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(ZZQAlertControllerStyle)preferredStyle
{
    ZZQAlertController *controller = [[ZZQAlertController alloc] init];
    controller.preferredStyle = preferredStyle;
    if (kiOS8Later) {
        controller.adaptiveAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(NSInteger)preferredStyle];
    }
    else {
        switch (preferredStyle) {
            case ZZQAlertControllerStyleActionSheet: {
                controller.adaptiveAlert = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@\n%@",title,message] delegate:controller cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
                break;
            }
            case ZZQAlertControllerStyleAlert: {
                controller.adaptiveAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:controller cancelButtonTitle:nil otherButtonTitles: nil];
                break;
            }
            default: {
                break;
            }
        }
    }
    return controller;
}

#pragma mark - getter&setter

- (NSArray<ZZQAlertAction *> *)actions
{
    return [self.mutableActions copy];
}

- (NSArray<UITextField *> *)textFields
{
    if (kiOS8Later) {
        return ((UIAlertController *)self.adaptiveAlert).textFields;
    }
    else {
        if ([self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
            switch (((UIAlertView *)self.adaptiveAlert).alertViewStyle) {
                case UIAlertViewStyleDefault: {
                    return @[];
                    break;
                }
                case UIAlertViewStyleSecureTextInput: {
                    return @[[((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:0]];
                    break;
                }
                case UIAlertViewStylePlainTextInput: {
                    return @[[((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:0]];
                    break;
                }
                case UIAlertViewStyleLoginAndPasswordInput: {
                    return @[[((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:0], [((UIAlertView *)self.adaptiveAlert) textFieldAtIndex:1]];
                    break;
                }
                default: {
                    break;
                }
            }
        }
        else {
            return nil;
        }
    }
}

- (NSString *)title
{
    return [self.adaptiveAlert title];
}

- (void)setTitle:(NSString *)title
{
    [self.adaptiveAlert setTitle:title];
}

- (NSString *)message
{
    return [self.adaptiveAlert message];
}

- (void)setMessage:(NSString *)message
{
    [self.adaptiveAlert setMessage:message];
}

- (UIAlertViewStyle)alertViewStyle
{
    if (!kiOS8Later&&[self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
        return [self.adaptiveAlert alertViewStyle];
    }
    return 0;
}

- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle
{
    if (!kiOS8Later&&[self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
        [self.adaptiveAlert setAlertViewStyle:alertViewStyle];
    }
}

- (ZZQAlertAction *)preferredAction
{
    if (kiOS9Later) {
        return (ZZQAlertAction *)[self.adaptiveAlert preferredAction];
    }
    return nil;
}

- (void)setPreferredAction:(ZZQAlertAction *)preferredAction
{
    if (kiOS9Later) {
        [self.adaptiveAlert setPreferredAction:preferredAction];
    }
}

- (void)addAction:(ZZQAlertAction *)action
{
    if (kiOS8Later) {
        [self.adaptiveAlert addAction:(UIAlertAction *)action];
    }
    else {
        [self.mutableActions addObject:action];
        
        NSInteger buttonIndex = [self.adaptiveAlert addButtonWithTitle:action.title];
        UIColor *textColor;
        switch (action.style) {
            case ZZQAlertActionStyleDefault: {
                textColor = self.tintColor;
                break;
            }
            case ZZQAlertActionStyleCancel: {
                [self.adaptiveAlert setCancelButtonIndex:buttonIndex];
                textColor = self.tintColor;
                break;
            }
            case ZZQAlertActionStyleDestructive: {
                [self.adaptiveAlert setDestructiveButtonIndex:buttonIndex];
                textColor = [UIColor redColor];
                break;
            }
            default: {
                textColor = self.tintColor;
                break;
            }
        }
        //        [((UIButton *)((UIView *)self.adaptiveAlert).subviews.lastObject) setTitleColor:textColor forState:0xFFFFFFFF];
    }
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler
{
    if (kiOS8Later) {
        [self.adaptiveAlert addTextFieldWithConfigurationHandler:configurationHandler];
    }
    else {
        if ([self.adaptiveAlert isKindOfClass:[UIAlertView class]]) {
            //TODO: UIAlertView 靠样式来添加 TextField，建议直接使用 iOS7CustomAlertView
            self.textFieldHandlers = [[NSArray arrayWithArray:self.textFieldHandlers] arrayByAddingObject:configurationHandler ?: ^(UITextField *textField){}];
            ((UIAlertView *)self.adaptiveAlert).alertViewStyle = self.textFieldHandlers.count > 1 ? UIAlertViewStyleLoginAndPasswordInput : UIAlertViewStylePlainTextInput;
        }
    }
}

#pragma mark - ZZQActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak __typeof(ZZQAlertAction *)weakAction = self.mutableActions[buttonIndex];
    if (self.mutableActions[buttonIndex].handler) {
        self.mutableActions[buttonIndex].handler(weakAction);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.ownerController.zzqAlertController = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    self.ownerController.zzqAlertController = nil;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    __weak __typeof(ZZQAlertAction *)weakAction = self.mutableActions[buttonIndex];
    if (self.mutableActions[buttonIndex].handler) {
        self.mutableActions[buttonIndex].handler(weakAction);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.ownerController.zzqAlertController = nil;
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    self.ownerController.zzqAlertController = nil;
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"view.tintColor"]) {
        self.tintColor = change[NSKeyValueChangeNewKey];
    }
}
@end
