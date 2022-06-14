//
//  ZooANRViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooANRViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/UIView+Zoo.h>
#import "ZooANRManager.h"
#import <Zoo/ZooCellButton.h>
#import "ZooANRListViewController.h"
#import <Zoo/Zooi18NUtil.h>
#import "ZooANRTool.h"
#import <Zoo/ZooDefine.h>

@interface ZooANRViewController () <ZooSwitchViewDelegate, ZooCellButtonDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;
@property (nonatomic, strong) ZooCellButton *checkBtn;
@property (nonatomic, strong) ZooCellButton *clearBtn;

@end

@implementation ZooANRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"卡顿检测");
    
    self.switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, 53)];
    [self.switchView renderUIWithTitle:ZooLocalizedString(@"卡顿检测开关") switchOn:[ZooANRManager sharedInstance].anrTrackOn];
    [self.switchView needTopLine];
    [self.switchView needDownLine];
    self.switchView.delegate = self;
    [self.view addSubview:self.switchView];
    
    self.checkBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, _switchView.zoo_bottom, self.view.zoo_width, 53)];
    [self.checkBtn renderUIWithTitle:ZooLocalizedString(@"查看卡顿记录")];
    self.checkBtn.delegate = self;
    [self.checkBtn needDownLine];
    [self.view addSubview:self.checkBtn];
    
    self.clearBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, self.checkBtn.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [self.clearBtn renderUIWithTitle:ZooLocalizedString(@"一键清理卡顿记录")];
    self.clearBtn.delegate = self;
    [self.clearBtn needDownLine];
    [self.view addSubview:self.clearBtn];
}

- (BOOL)needBigTitleView {
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender {
    [ZooANRManager sharedInstance].anrTrackOn = on;
    if (on) {
        [[ZooANRManager sharedInstance] start];
    } else {
        [[ZooANRManager sharedInstance] stop];
    }
}

#pragma mark -- ZooCellButtonDelegate
- (void)cellBtnClick:(id)sender {
    if (sender == self.checkBtn) {
        ZooANRListViewController *vc = [[ZooANRListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender == self.clearBtn) {
           UIAlertController * alertController = [UIAlertController alertControllerWithTitle:ZooLocalizedString(@"提示") message:ZooLocalizedString(@"确认删除所有卡顿记录吗？") preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           }];
           UIAlertAction *okAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               NSFileManager *fm = [NSFileManager defaultManager];
               if ([fm removeItemAtPath:[ZooANRTool anrDirectory] error:nil]) {
                   [ZooToastUtil showToast:ZooLocalizedString(@"删除成功") inView:self.view];
               } else {
                   [ZooToastUtil showToast:ZooLocalizedString(@"删除失败") inView:self.view];
               }
           }];
           [alertController addAction:cancelAction];
           [alertController addAction:okAction];
           [self presentViewController:alertController animated:YES completion:nil];
       }
}

@end
