//
//  ZooCPUViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCPUViewController.h"
#import "ZooCacheManager+Performance.h"
#import "ZooCPUOscillogramWindow.h"
#import <Zoo/Zooi18NUtil.h>
#import "ZooCPUOscillogramViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooDefine.h>

@interface ZooCPUViewController ()<ZooSwitchViewDelegate, ZooOscillogramWindowDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;

@end

@implementation ZooCPUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"CPU检测");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"CPU检测开关") switchOn:[[ZooCacheManager sharedInstance] cpuSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    [[ZooCPUOscillogramWindow shareInstance] addDelegate:self];
}

- (BOOL)needBigTitleView{
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[ZooCacheManager sharedInstance] saveCpuSwitch:on];
    if(on){
        [[ZooCPUOscillogramWindow shareInstance] show];
    }else{
        [[ZooCPUOscillogramWindow shareInstance] hide];
    }
}

#pragma mark -- ZooOscillogramWindowDelegate
- (void)zooOscillogramWindowClosed {
    [_switchView renderUIWithTitle:ZooLocalizedString(@"CPU检测开关") switchOn:[[ZooCacheManager sharedInstance] cpuSwitch]];
}

@end
