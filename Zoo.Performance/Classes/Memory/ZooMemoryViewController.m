//
//  ZooMemoryViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooMemoryViewController.h"
#import "ZooCacheManager+Performance.h"
#import "ZooMemoryOscillogramWindow.h"
#import "ZooMemoryOscillogramViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooDefine.h>

@interface ZooMemoryViewController ()<ZooSwitchViewDelegate, ZooOscillogramWindowDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;

@end

@implementation ZooMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"内存检测");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"内存检测开关") switchOn:[[ZooCacheManager sharedInstance] memorySwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    [[ZooMemoryOscillogramWindow shareInstance] addDelegate:self];
}

- (BOOL)needBigTitleView{
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[ZooCacheManager sharedInstance] saveMemorySwitch:on];
    if(on){
        [[ZooMemoryOscillogramWindow shareInstance] show];
    }else{
        [[ZooMemoryOscillogramWindow shareInstance] hide];
    }
}

#pragma mark -- ZooOscillogramWindowDelegate
- (void)zooOscillogramWindowClosed {
    [_switchView renderUIWithTitle:ZooLocalizedString(@"内存检测开关") switchOn:[[ZooCacheManager sharedInstance] memorySwitch]];
}

@end
