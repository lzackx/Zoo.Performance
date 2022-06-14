//
//  ZooCPUPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCPUPlugin.h"
#import "ZooCPUViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooCPUPlugin

- (void)pluginDidLoad{
    ZooCPUViewController *vc = [[ZooCPUViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
