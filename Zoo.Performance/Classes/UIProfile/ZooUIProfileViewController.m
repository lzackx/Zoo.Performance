//
//  ZooUIProfileViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooUIProfileViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooDefine.h>
#import "ZooUIProfileManager.h"
#import <Zoo/ZooHomeWindow.h>

@interface ZooUIProfileViewController () <ZooSwitchViewDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;

@end

@implementation ZooUIProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ZooLocalizedString(@"UI层级");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"UI层级检查开关") switchOn:[ZooUIProfileManager sharedInstance].enable];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
}

- (BOOL)needBigTitleView{
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [ZooUIProfileManager sharedInstance].enable = on;
    [[ZooHomeWindow shareInstance] hide];
}

@end
