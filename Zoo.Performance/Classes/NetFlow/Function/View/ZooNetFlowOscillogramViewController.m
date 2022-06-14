//
//  ZooNetFlowOscillogramViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowOscillogramViewController.h"
#import "ZooOscillogramView.h"
#import "ZooNetFlowDataSource.h"
#import <Zoo/ZooDefine.h>
#import "ZooCacheManager+Performance.h"
#import "ZooNetFlowOscillogramWindow.h"

@interface ZooNetFlowOscillogramViewController ()

@end

@implementation ZooNetFlowOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title{
    return ZooLocalizedString(@"网络监控");
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return [NSString stringWithFormat:@"%zi",[self highestNetFlow]];
}

- (void)closeBtnClick{
    [[ZooCacheManager sharedInstance] saveNetFlowSwitch:NO];
    [[ZooNetFlowOscillogramWindow shareInstance] hide];
}

//每一秒钟采样一次流量情况
- (void)doSecondFunction{
    NSUInteger useNetFlowForApp = 0.;
    NSUInteger totalNetFlowForDevice = [self highestNetFlow];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval start = now - 1;
    
    NSMutableArray<ZooNetFlowHttpModel *> *httpModelArray = [ZooNetFlowDataSource shareInstance].httpModelArray;
    
    NSInteger totalNetFlow = 0.;
    for (ZooNetFlowHttpModel *httpModel in httpModelArray) {
        NSTimeInterval netFlowEndTime = httpModel.endTime;
        if (netFlowEndTime >= start && netFlowEndTime <= now) {
            NSString *upFlow = httpModel.uploadFlow;
            NSString *downFlow = httpModel.downFlow;
            NSUInteger upFlowInt = [upFlow integerValue];
            NSUInteger downFlowInt = [downFlow integerValue];
            totalNetFlow += (upFlowInt + downFlowInt);
        }
    }
    
    useNetFlowForApp = totalNetFlow;
    
    // 0~highestNetFlow   对应 高度0~200
    [self.oscillogramView addHeightValue:useNetFlowForApp*self.oscillogramView.zoo_height/totalNetFlowForDevice andTipValue:[NSString stringWithFormat:@"%ziB",useNetFlowForApp]];
}

- (NSUInteger)highestNetFlow {
    return 1000;//10000Byte
}

@end
