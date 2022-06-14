//
//  ZooFPSViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooFPSViewController.h"
#import "ZooCacheManager+Performance.h"
#import "ZooFPSOscillogramWindow.h"
#import "ZooFPSOscillogramViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooDefine.h>

@interface ZooFPSViewController ()<ZooSwitchViewDelegate, ZooOscillogramWindowDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;

@end

@implementation ZooFPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"帧率检测");
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"帧率检测开关") switchOn:[[ZooCacheManager sharedInstance] fpsSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    [[ZooFPSOscillogramWindow shareInstance] addDelegate:self];
}


- (BOOL)needBigTitleView{
    return YES;
}


#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[ZooCacheManager sharedInstance] saveFpsSwitch:on];
    if(on){
        [[ZooFPSOscillogramWindow shareInstance] show];
    }else{
        [[ZooFPSOscillogramWindow shareInstance] hide];
    }
}

#pragma mark -- ZooOscillogramWindowDelegate
- (void)zooOscillogramWindowClosed {
    [_switchView renderUIWithTitle:ZooLocalizedString(@"帧率检测开关") switchOn:[[ZooCacheManager sharedInstance] fpsSwitch]];
}

@end
