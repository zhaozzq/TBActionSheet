//
//  ViewController.m
//  ZZQAlertControllerDemo
//
//  Created by 杨萧玉 on 15/12/15.
//  Copyright © 2015年 杨萧玉. All rights reserved.
//

#import "ViewController.h"
#import "ZZQActionSheet.h"
#import "ZZQAlertController.h"
#import "ConditionerView.h"

@interface ViewController () <ZZQActionSheetDelegate>
@property (nonnull,nonatomic) NSObject *leakTest;
@property (nonnull,nonatomic) ConditionerView *conditioner;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _leakTest = [NSObject new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickActionSheet:(UIButton *)sender {
    ZZQActionSheet *actionSheet = [[ZZQActionSheet alloc] initWithTitle:@"MagicalActionSheet" message:@"巴拉巴拉小魔仙，变！" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"销毁" otherButtonTitles:nil];
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ConditionerView" owner:nil options:nil];
    self.conditioner = views[0];
    self.conditioner.frame = CGRectMake(0, 0, [ZZQActionSheet appearance].sheetWidth, 400);
    self.conditioner.actionSheet = actionSheet;
    actionSheet.customView = self.conditioner;
    
    [actionSheet addButtonWithTitle:@"支持 block" style:ZZQActionButtonStyleDefault handler:^(ZZQActionButton * _Nonnull button) {
        NSLog(@"%@ %@",button.currentTitle,self.leakTest);
    }];
    [actionSheet showInView:self.view];
    [self.conditioner setUpUI];
}

- (IBAction)clickControllerWithAlert:(UIButton *)sender {
    ZZQAlertController *controller = [ZZQAlertController alertControllerWithTitle:@"ZZQAlertController" message:@"AlertStyle" preferredStyle:ZZQAlertControllerStyleAlert];
    ZZQAlertAction *clickme = [ZZQAlertAction actionWithTitle:@"点我" style: ZZQAlertActionStyleDefault handler:^(ZZQAlertAction * _Nonnull action) {
        NSLog(@"%@ %@",action.title,self.leakTest);
    }];
    ZZQAlertAction *cancel = [ZZQAlertAction actionWithTitle:@"取消" style: ZZQAlertActionStyleCancel handler:^(ZZQAlertAction * _Nonnull action) {
        NSLog(@"%@ %@",action.title,self.leakTest);
    }];
    [controller addAction:clickme];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)clickControllerWithActionSheet:(UIButton *)sender {
    ZZQAlertController *controller = [ZZQAlertController alertControllerWithTitle:@"ZZQAlertController" message:@"AlertStyle" preferredStyle:ZZQAlertControllerStyleActionSheet];
    ZZQAlertAction *clickme = [ZZQAlertAction actionWithTitle:@"点我" style: ZZQAlertActionStyleDefault handler:^(ZZQAlertAction * _Nonnull action) {
        NSLog(@"%@ %@",action.title,self.leakTest);
    }];
    ZZQAlertAction *cancel = [ZZQAlertAction actionWithTitle:@"取消" style: ZZQAlertActionStyleCancel handler:^(ZZQAlertAction * _Nonnull action) {
        NSLog(@"%@ %@",action.title,self.leakTest);
    }];
    [controller addAction:clickme];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark - ZZQActionSheetDelegate

- (void)actionSheet:(ZZQActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click button:%ld",(long)buttonIndex);
}

- (void)actionSheet:(ZZQActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismiss");
}

- (void)actionSheet:(ZZQActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismiss");
}

@end
