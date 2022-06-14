//
//  ZooMemoryPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooMemoryPlugin.h"
#import "ZooMemoryViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooMemoryPlugin

- (void)pluginDidLoad{
    ZooMemoryViewController *vc = [[ZooMemoryViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
