//
//  ZooWeakNetworkViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooWeakNetworkViewController.h"
#import "ZooWeakNetworkManager.h"
#import <Zoo/ZooCellSwitch.h>
#import "ZooWeakNetworkDetailView.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/ZooToastUtil.h>
#import "ZooWeakNetworkWindow.h"

@interface ZooWeakNetworkViewController()<ZooWeakNetworkWindowDelegate>

@property (nonatomic, strong) ZooCellSwitch *weakSwitchView;
@property (nonatomic, strong) ZooWeakNetworkDetailView *detail;

@end

@implementation ZooWeakNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"模拟弱网测试");
    
    _weakSwitchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_weakSwitchView renderUIWithTitle:ZooLocalizedString(@"弱网模式") switchOn:[ZooWeakNetworkManager shareInstance].shouldWeak];
    [_weakSwitchView.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_weakSwitchView needDownLine];
    [self.view addSubview:_weakSwitchView];
    [ZooWeakNetworkWindow shareInstance].delegate = self;
    _detail = [[ZooWeakNetworkDetailView alloc] initWithFrame:CGRectMake(0, _weakSwitchView.zoo_bottom , self.view.zoo_width, self.view.zoo_height - _weakSwitchView.zoo_bottom)];
    _detail.hidden = ![ZooWeakNetworkManager shareInstance].shouldWeak;
    [self.view addSubview:_detail];
}

- (BOOL)needBigTitleView{
    return YES;
}

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    [ZooWeakNetworkManager shareInstance].shouldWeak = [switchButton isOn];
    
    [[ZooWeakNetworkManager shareInstance] canInterceptNetFlow:[switchButton isOn]];
    _detail.hidden = ![switchButton isOn];
    [ZooWeakNetworkWindow shareInstance].hidden = _detail.hidden;
    if([switchButton isOn]){
        [[ZooWeakNetworkManager shareInstance] startRecord];
    }else{
        [[ZooWeakNetworkManager shareInstance] endRecord];
    }
}

#pragma mark - ZooWeakNetworkWindowDelegate
- (void)zooWeakNetworkWindowClosed {
    _weakSwitchView.switchView.on = NO;
    _detail.hidden = YES;
}

@end
