//
//  ZooNetFlowOscillogramWindow.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNetFlowOscillogramWindow.h"
#import "ZooNetFlowOscillogramViewController.h"

@implementation ZooNetFlowOscillogramWindow

+ (ZooNetFlowOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static ZooNetFlowOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[ZooNetFlowOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    ZooNetFlowOscillogramViewController *vc = [[ZooNetFlowOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}

@end
