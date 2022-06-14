//
//  ZooCPUOscillogramViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCPUOscillogramViewController.h"
#import "ZooOscillogramView.h"
#import "ZooCPUUtil.h"
#import <Zoo/ZooDefine.h>
#import "ZooCacheManager+Performance.h"
#import "ZooCPUOscillogramWindow.h"

@interface ZooCPUOscillogramViewController ()


@end

@implementation ZooCPUOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title{
    return ZooLocalizedString(@"CPU检测");
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"100";
}

- (void)closeBtnClick{
    [[ZooCacheManager sharedInstance] saveCpuSwitch:NO];
    [[ZooCPUOscillogramWindow shareInstance] hide];
}

//每一秒钟采样一次cpu使用率
- (void)doSecondFunction{
    CGFloat cpuUsage = [ZooCPUUtil cpuUsageForApp];
    if (cpuUsage * 100 > 100) {
        cpuUsage = 100;
    }else{
        cpuUsage = cpuUsage * 100;
    }
    // 0~100   对应 高度0~_oscillogramView.zoo_height
    [self.oscillogramView addHeightValue:cpuUsage*self.oscillogramView.zoo_height/100. andTipValue:[NSString stringWithFormat:@"%.f",cpuUsage]];
}

@end
