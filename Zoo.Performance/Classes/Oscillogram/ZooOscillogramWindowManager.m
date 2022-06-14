//
//  ZooOscillogramWindowManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooOscillogramWindowManager.h"
#import "ZooFPSOscillogramWindow.h"
#import "ZooCPUOscillogramWindow.h"
#import "ZooMemoryOscillogramWindow.h"
#import "ZooNetFlowOscillogramWindow.h"
#import <Zoo/ZooDefine.h>

@interface ZooOscillogramWindowManager()

@property (nonatomic, strong) ZooFPSOscillogramWindow *fpsWindow;
@property (nonatomic, strong) ZooCPUOscillogramWindow *cpuWindow;
@property (nonatomic, strong) ZooMemoryOscillogramWindow *memoryWindow;
@property (nonatomic, strong) ZooNetFlowOscillogramWindow *netflowWindow;

@end

@implementation ZooOscillogramWindowManager

+ (ZooOscillogramWindowManager *)shareInstance{
    static dispatch_once_t once;
    static ZooOscillogramWindowManager *instance;
    dispatch_once(&once, ^{
        instance = [[ZooOscillogramWindowManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _fpsWindow = [ZooFPSOscillogramWindow shareInstance];
        _cpuWindow = [ZooCPUOscillogramWindow shareInstance];
        _memoryWindow = [ZooMemoryOscillogramWindow shareInstance];
        _netflowWindow = [ZooNetFlowOscillogramWindow shareInstance];
    }
    return self;
}

- (void)resetLayout{
    CGFloat offsetY = 0;
    CGFloat width = 0;
    CGFloat height = kZooSizeFrom750_Landscape(240);
    if (kInterfaceOrientationPortrait){
        width = ZooScreenWidth;
        offsetY = IPHONE_TOPSENSOR_HEIGHT;
    }else{
        width = ZooScreenHeight;
    }
    if (!_fpsWindow.hidden) {
        _fpsWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _fpsWindow.zoo_height+kZooSizeFrom750_Landscape(4);
    }
    
    if (!_cpuWindow.hidden) {
        _cpuWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _cpuWindow.zoo_height+kZooSizeFrom750_Landscape(4);
    }
    
    if (!_memoryWindow.hidden) {
        _memoryWindow.frame = CGRectMake(0, offsetY, width, height);
        offsetY += _memoryWindow.zoo_height+kZooSizeFrom750_Landscape(4);
    }
    
    if (!_netflowWindow.hidden) {
        _netflowWindow.frame = CGRectMake(0, offsetY, width, height);
    }
    
}

@end
