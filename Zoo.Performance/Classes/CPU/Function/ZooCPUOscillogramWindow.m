//
//  ZooCPUOscillogramWindow.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCPUOscillogramWindow.h"
#import "ZooCPUOscillogramViewController.h"

@implementation ZooCPUOscillogramWindow

+ (ZooCPUOscillogramWindow *)shareInstance{
    static dispatch_once_t once;
    static ZooCPUOscillogramWindow *instance;
    dispatch_once(&once, ^{
        instance = [[ZooCPUOscillogramWindow alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (void)addRootVc{
    ZooCPUOscillogramViewController *vc = [[ZooCPUOscillogramViewController alloc] init];
    self.rootViewController = vc;
    self.vc = vc;
}


@end
