//
//  ZooFPSOscillogramViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooFPSOscillogramViewController.h"
#import "ZooOscillogramView.h"
#import <Zoo/ZooDefine.h>
#import "ZooCacheManager+Performance.h"
#import "ZooFPSOscillogramWindow.h"
#import "ZooFPSUtil.h"


@interface ZooFPSOscillogramViewController ()

@property (nonatomic, strong) ZooFPSUtil *fpsUtil;

@end

@implementation ZooFPSOscillogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *)title{
    return ZooLocalizedString(@"帧率检测");
}

- (NSString *)lowValue{
    return @"0";
}

- (NSString *)highValue{
    return @"60";
}


- (void)closeBtnClick{
    [[ZooCacheManager sharedInstance] saveFpsSwitch:NO];
    [[ZooFPSOscillogramWindow shareInstance] hide];
}

- (void)startRecord{
    if (!_fpsUtil) {
        _fpsUtil = [[ZooFPSUtil alloc] init];
        __weak typeof(self) weakSelf = self;
        [_fpsUtil addFPSBlock:^(NSInteger fps) {
            // 0~60   对应 高度0~_oscillogramView.zoo_height
            [weakSelf.oscillogramView addHeightValue:fps*weakSelf.oscillogramView.zoo_height/60. andTipValue:[NSString stringWithFormat:@"%zi",fps]];
        }];
    }
    [_fpsUtil start];
}

- (void)endRecord{
    if (_fpsUtil) {
        [_fpsUtil end];
    }
    [self.oscillogramView clear];
}

@end
