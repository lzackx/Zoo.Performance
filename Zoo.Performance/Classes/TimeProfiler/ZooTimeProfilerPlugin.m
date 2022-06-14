//
//  ZooTimeProfilerPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooTimeProfilerPlugin.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooTimeProfilerViewController.h"

@implementation ZooTimeProfilerPlugin

- (void)pluginDidLoad{
    ZooTimeProfilerViewController *vc = [[ZooTimeProfilerViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
